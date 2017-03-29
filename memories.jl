#!/usr/bin/env julia

module memories

using StatsBase
using PyPlot

include("plotting.jl")

p = plotting


m0 = [
0 0 0 0 0 0 0 0 0 0;
0 0 0 1 1 1 1 0 0 0;
0 0 1 1 0 0 1 1 0 0;
0 0 1 0 0 0 0 1 0 0;
0 0 1 0 0 0 0 1 0 0;
0 0 1 0 0 0 0 1 0 0;
0 0 1 0 0 0 0 1 0 0;
0 0 1 1 0 0 1 1 0 0;
0 0 0 1 1 1 1 0 0 0;
0 0 0 0 0 0 0 0 0 0 ]

m1 = [
0 0 0 0 0 0 0 0 0 0;
0 0 0 1 1 1 0 0 0 0;
0 0 0 1 1 1 0 0 0 0;
0 0 0 0 1 1 0 0 0 0;
0 0 0 0 1 1 0 0 0 0;
0 0 0 0 1 1 0 0 0 0;
0 0 0 0 1 1 0 0 0 0;
0 0 1 1 1 1 1 1 0 0;
0 0 1 1 1 1 1 1 0 0;
0 0 0 0 0 0 0 0 0 0 ]

m2 = [
0 0 0 1 1 1 1 0 0 0;
0 0 0 1 1 1 1 1 0 0;
0 0 0 1 1 0 1 1 0 0;
0 0 0 1 0 0 1 1 0 0;
0 0 0 0 0 1 1 1 0 0;
0 0 0 0 1 1 1 0 0 0;
0 0 0 1 1 1 0 0 0 0;
0 0 1 1 1 0 0 0 0 0;
0 0 1 1 1 1 1 1 0 0;
0 0 1 1 1 1 1 1 0 0 ]

m3 = [
0 0 0 0 0 0 0 0 0 0;
0 0 0 1 1 1 1 1 0 0;
0 0 0 1 0 0 1 1 0 0;
0 0 1 1 0 0 1 1 0 0;
0 0 0 0 0 0 1 1 0 0;
0 0 0 0 1 1 1 0 0 0;
0 0 0 0 0 0 1 1 0 0;
0 0 1 1 0 0 1 1 0 0;
0 0 0 1 1 1 1 1 0 0;
0 0 0 0 0 0 0 0 0 0 ]

m4 = [
0 0 0 0 0 0 0 0 0 0;
0 0 0 0 1 1 1 1 0 0;
0 0 0 1 1 0 1 1 0 0;
0 0 1 1 0 0 1 1 0 0;
0 1 1 0 0 0 1 1 0 0;
0 1 1 1 1 1 1 1 1 0;
0 0 0 0 0 0 1 1 0 0;
0 0 0 0 0 0 1 1 0 0;
0 0 0 0 1 1 1 1 1 0;
0 0 0 0 0 0 0 0 0 0 ]


mA = [
0 0 0 1 1 1 1 0 0 0;
0 0 0 1 1 1 1 0 0 0;
0 0 1 1 0 0 1 1 0 0;
0 0 1 1 0 0 1 1 0 0;
0 0 1 1 0 0 1 1 0 0;
0 1 1 0 0 0 0 1 1 0;
0 1 1 0 0 0 0 1 1 0;
0 1 1 1 1 1 1 1 1 0;
1 1 0 0 0 0 0 0 1 1;
1 1 0 0 0 0 0 0 1 1 ]


mB = [
0 1 1 1 1 1 1 0 0 0;
0 1 1 0 0 0 1 1 0 0;
0 1 1 0 0 0 1 1 0 0;
0 1 1 0 0 0 1 1 0 0;
0 1 1 1 1 1 1 0 0 0;
0 1 1 0 0 0 1 1 0 0;
0 1 1 0 0 0 1 1 0 0;
0 1 1 0 0 0 1 1 0 0;
0 1 1 0 0 0 1 1 0 0;
0 1 1 1 1 1 1 0 0 0 ]


mC = [
0 0 0 1 1 1 1 1 0 0;
0 0 1 1 0 0 0 1 1 0;
0 1 1 0 0 0 0 0 0 0;
0 1 0 0 0 0 0 0 0 0;
0 1 0 0 0 0 0 0 0 0;
0 1 0 0 0 0 0 0 0 0;
0 1 0 0 0 0 0 0 0 0;
0 1 1 0 0 0 0 0 0 0;
0 0 1 1 0 0 0 1 1 0;
0 0 0 1 1 1 1 1 0 0 ]

active_memories = [mA,mB,mC];

function load_memories()

  flip(X) = X[end:-1:1,:]

  args = [ flip(mem)[:] for mem in active_memories ]
  
  hcat( args... )
end


function corrupted_memory( mem_i, corruption )

  mems = load_memories()

  corrupted_memory( mems, mem_i, corruption )
end


function corrupted_memory( mems, mem_i, corruption )

  V = mems[:,mem_i]

  num_to_corrupt = round(Int,corruption*length(V))
  corrupted_i = StatsBase.sample(1:length(V),num_to_corrupt; replace=false)
  sort!(corrupted_i)

  T = eltype(V)
  for i in corrupted_i
    V[i] = 1 - V[i]
  end

  V
end


function plot_memory(mem_i, mems=nothing)

  if mems == nothing mems = load_memories() end

  p.plot_heatmap(mems[:,mem_i])
end


function plot_all_memories(new_fig=true, mems=nothing)

  if mems == nothing mems = load_memories() end

  num_mems = size(mems,2)
  num_rows = round(Int,ceil(num_mems/2))

  if new_fig == true PyPlot.figure() end

  for i in 1:num_mems
    PyPlot.subplot(num_rows,2,i)
    p.plot_heatmap( mems[:,i] )
  end

end 

function plot_corrupted_memory( mem_i, corruption, new_fig=true, mems=nothing )

  if mems == nothing mems = load_memories() end

  p.plot_heatmap( corrupted_memory(mems, mem_i, corruption), new_fig )
end
 
 
end #module end
