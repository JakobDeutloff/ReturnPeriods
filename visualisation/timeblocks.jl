using NetCDF

function read_ensemble_memeber(file, varname)
    data = NetCDF.open(file, varname)
    return data
end

function sliding_time(data)
    max_value = data[:,:,1]
    summed_value = data[:,:,1]
    for t in 1:(length(data[1,1,:])-24)
        summed_value .= sum(data[:,:,t:t+24], dims=3)
        max_value .= max.(summed_value[:,:], max_value[:,:])
    end
    return max_value
end

function write2nc(file,summed_value, outputfile)
    lonname = "projection_x_coordinate"
    latname = "projection_y_coordinate"
    x = NetCDF.open(file, lonname)
    y = NetCDF.open(file, latname)
    varatts = Dict("longname" => "amount_of_precipitation", "grid_mapping" => "transverse_mercator", "units"    => "mm/d")
    xatts = Dict("standard_name" => "projection_x_coordinate", "units"    => "m", "axis" => "X")
    yatts = Dict("standard_name" => "projection_y_coordinate", "units"    => "m", "axis" => "Y")
    fn = joinpath(pwd(),outputfile)
    isfile(fn) && rm(fn)
    nccreate(fn,"amount_of_precipitation","projection_x_coordinate",x[:],xatts,"projection_y_coordinate",y[:],yatts,atts=varatts)
    ncwrite(summed_value,fn,"amount_of_precipitation")
    ncclose(fn)
end

scenario = range(0,11)
base = joinpath("../../202002080300")
varname = "amount_of_precipitation"
for i in scenario
    @show i
    filename = string("202002080300_u1096_ng_ek",lpad(string(i),2,'0'),"_precipaccum_2km.nc")
    outputfile = joinpath(pwd(),"processed",string("member",i,".nc"))
    file = joinpath(base,filename)
    data = read_ensemble_memeber(file, varname)
    max_value = sliding_time(data)
    print("Finished Max Calculation \n")
    write2nc(file,max_value, outputfile)
end
