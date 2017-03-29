#!/usr/bin/env julia


module discrete

include("plotting.jl"); plt = plotting
include("memories.jl"); mem = memories


function random_trial( num_time_steps = 500 )

  mems = mem.load_memories()

  T = find_weights(mems)

  V = rand_V(size(T,1))

  run(V, T, num_time_steps)
end


function corrupt_trial( base_mem, corruption, num_time_steps = 500 )

  mems = mem.load_memories()

  T = find_weights(mems)

  V = mem.corrupted_memory( mems, base_mem, corruption )

  run(V, T, num_time_steps)
end


function run(V, T, num_time_steps = 500)

  t = 0
  if num_time_steps == nothing num_time_steps = -1 end

  p = plt.plot_heatmap(V, true)
  show(p)

  println("Enter to continue")
  readline(STDIN)
  while t != num_time_steps

    print("\r Update #$t")
    update_V!( V, T )
    plt.plot_heatmap(V)
    sleep(0.01)

    t += 1
  end

  V, T
end


"""
stimuli should be encoded as the columns of a matrix
"""
function find_weights(stimuli)

  scaled = 2*stimuli - 1

  W = scaled*scaled'
  for i in 1:size(W,1) W[i,i] = 0 end

  W
end


function rand_V(num_units, T=UInt8)
  return round(T, rand(Bool,(num_units,)))
end


function update_all!(V,T)

  inputs = T*V

  for i in eachindex(V)
    if inputs[i] > 0     V[i] = 1
    elseif inputs[i] < 0 V[i] = 0
    end
  end

end

function update_V!(V, T)

  inputs = T*V

  i = rand(1:length(V))

  if inputs[i] > 0     V[i] = 1
  elseif inputs[i] < 0 V[i] = 0
  end

end


end #module end
