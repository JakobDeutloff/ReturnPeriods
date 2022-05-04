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
	using HDF5
	using Unitful
	using UnitfulRecipes
	using PlutoUI
    using GMT
	using NetCDF
end

# ╔═╡ 3805a307-ce89-49da-a32d-fbf89833e956
begin
	scenarios = range(1,11)
	md"""
	Select the scenario
	$(@bind scenario Slider(1:length(scenarios)))
	"""
end

# ╔═╡ 06d6af62-7d22-4967-b9a9-e60b6afbcc1a
begin
	times = [0,1,2,3]
	md"""
	Select the time
	$(@bind time_slice Slider(1:length(times)))
	"""
end

# ╔═╡ afce6da7-3e48-49a6-8489-eb2acb2fd410
function read_forecast(scenario, time_slice)
	base = joinpath("../../202002060300")
	filename = string("202002060300_u1096_ng_ek",lpad(string(scenario),2,'0'),"_precipaccum_2km.nc")
	varname = "amount_of_precipitation"
	v = NetCDF.open(joinpath(base,filename), varname)
	data = v[:,:,time_slice]
	return data
end

# ╔═╡ cf27a2ef-bf6c-4415-a6be-5f095241d218
begin
	G = read_forecast(scenario, time_slice)
	grdimage(G, title="Ensemble Member No. $scenario", show=true)
end

# ╔═╡ Cell order:
# ╟─c7383ff4-ba4c-11eb-1977-b31b330b20d0
# ╟─3805a307-ce89-49da-a32d-fbf89833e956
# ╟─06d6af62-7d22-4967-b9a9-e60b6afbcc1a
# ╠═cf27a2ef-bf6c-4415-a6be-5f095241d218
# ╠═afce6da7-3e48-49a6-8489-eb2acb2fd410
