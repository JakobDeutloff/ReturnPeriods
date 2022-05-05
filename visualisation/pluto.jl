### A Pluto.jl notebook ###
# v0.18.2

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ c7383ff4-ba4c-11eb-1977-b31b330b20d0
begin
	import Pkg
	Pkg.activate(@__DIR__)
	Pkg.instantiate()
	using PlutoUI
    using GMT
	using NetCDF
end

# ╔═╡ 3805a307-ce89-49da-a32d-fbf89833e956
begin
	scenarios = range(1,11)
	md"""
	Select the ensemble member
	$(@bind scenario Slider(1:length(scenarios)))
	"""
end

# ╔═╡ afce6da7-3e48-49a6-8489-eb2acb2fd410
function read_forecast(scenario, time_slice)
	base = joinpath("../../202002080300")
	filename = string("202002060300_u1096_ng_ek",lpad(string(scenario),2,'0'),"_precipaccum_2km.nc")
	varname = "amount_of_precipitation"
	v = NetCDF.open(joinpath(base,filename), varname)
	data = v[:,:,time_slice]
	return data
end

# ╔═╡ 7a475e4b-84b4-472b-80ff-6c8f2bdd4493
function read_processed(scenario)
	filename = joinpath(pwd(),"processed",string("member",scenario,".nc"))
	varname = "amount_of_precipitation"
	v = NetCDF.open(filename, varname)
	data = v[:,:]
	return data
end
	

# ╔═╡ c690e895-0e96-4428-be50-fa0631cea4b2
function read_ERA(file, varname)
	v = NetCDF.open(file, varname)
	data = v[:,:]
	return data
end

# ╔═╡ 592ed9ba-59ee-470f-8f22-79bee034d87f
function return_period!(period, rain, times)
	for year in times
		ERA = joinpath("../Return_Periods_ERA5/regridded",string("ERA_RP_",year,".nc"))
		var = string("r",year,"yrrp")
		return_estimate = read_ERA(ERA, var)
		rain = Float32.(rain)
		for x in 1:length(rain[:,1])
			for y in 1:length(rain[1,:])
				if return_estimate[x,y] < 10000.0
					if rain[x,y] > return_estimate[x,y]
						period[x,y] = year
					end
				end
			end
		end
	end 
end

# ╔═╡ 3cffff75-ac0e-42b7-b531-5622bae02bc4
function read_ensemble_member(file, varname)
    data = NetCDF.open(file, varname)
    return data
end

# ╔═╡ e89ff02d-ddb9-4527-9e67-50b475c5fc28
function sliding_time(data)
    max_value = data[:,:,1]
    summed_value = data[:,:,1]
    for t in 1:(length(data[1,1,:])-24)
        summed_value .= sum(data[:,:,t:t+24], dims=3)
        max_value .= max.(summed_value[:,:], max_value[:,:])
    end
    return max_value
end

# ╔═╡ cf27a2ef-bf6c-4415-a6be-5f095241d218
begin
	# Set up some local paths and fixed variables
	times = [5,10,25,50,100]
	base = joinpath("../ForecastData/ensemble_files")
	varname = "amount_of_precipitation"
	# Load in the ensemble member
	filename = string("202002080300_u1096_ng_ek",lpad(string(scenario),2,'0'),"_precipaccum_2km.nc")
    file = joinpath(base,filename)
    data = read_ensemble_member(file, varname)
	# Calculating the accumlated rain fall over 24 hour windows
	# Each forecast has a 54-hour lead time 
    max_value = sliding_time(data)
	# Set up dummy array for the return period array
	period = zeros(size(max_value))
	# Calculate return period from ERA file
	return_period!(@view(period[:,:]), max_value[:,:], times)
	# Plotting 
	topo = makecpt(color=:ocean, range=[0,5,10,25,50,100], inverse=true)
	period = adjoint(period)
	grdimage(period[:,:], title="Ensemble Member No. $scenario",  color=topo)
	coast!(projection="t-2.0/0.9996012717", region="-11.5/16/44/62")
	colorbar!(equal=(range=true,), show=true)
end

# ╔═╡ Cell order:
# ╠═c7383ff4-ba4c-11eb-1977-b31b330b20d0
# ╟─3805a307-ce89-49da-a32d-fbf89833e956
# ╠═cf27a2ef-bf6c-4415-a6be-5f095241d218
# ╟─afce6da7-3e48-49a6-8489-eb2acb2fd410
# ╟─7a475e4b-84b4-472b-80ff-6c8f2bdd4493
# ╟─c690e895-0e96-4428-be50-fa0631cea4b2
# ╟─592ed9ba-59ee-470f-8f22-79bee034d87f
# ╟─3cffff75-ac0e-42b7-b531-5622bae02bc4
# ╟─e89ff02d-ddb9-4527-9e67-50b475c5fc28
