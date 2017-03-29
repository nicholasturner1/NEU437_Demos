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
    async_update!( V, T )
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


function sync_update!(V,T)

  inputs = T*V

  for i in eachindex(V)
    if inputs[i] > 0     V[i] = 1
    elseif inputs[i] < 0 V[i] = 0
    end
  end

end


function async_update!(V, T)

  inputs = T*V

  i = rand(1:length(V))

  if inputs[i] > 0     V[i] = 1
  elseif inputs[i] < 0 V[i] = 0
  end

end


function fill_band!(T, j, band, exc_val, inh_val)

  for i in 1:size(T,1)
    #if the band wraps around borders
    if band[1] > band[2] && (i >= band[1] || i <= band[2])
      T[i,j] = exc_val  
      continue 
    elseif band[1] < band[2] && i >= band[1] && i <= band[2]
      T[i,j] = exc_val
      continue
    elseif band[1] == band[2] && i == band[1]
      T[i,j] = exc_val
      continue
    end
      
    T[i,j] = inh_val
  end
    
end


"""
"""
function banded_T( num_units, exc_val = 1, inh_val = -1, band_width=1 )

  tT = typeof(exc_val) #determining type
  T = Array{tT,2}(num_units,num_units)

  for j in 1:num_units

    #determining bounds for the band
    exc_is = [ j-band_width, j + band_width ]
    if exc_is[1] < 1          exc_is[1] += num_units end
    if exc_is[2] > num_units  exc_is[2] -= num_units end

    fill_band!(T,j,exc_is,exc_val,inh_val)
  end

  T
end


function leading_T( num_units, exc_val = 1, inh_val = -1, band_width = 1 )

  tT = typeof(exc_val) #determining type
  T = Array{tT,2}(num_units,num_units)

  for j in 1:num_units

    #bounds for the band
    exc_is = [ j - band_width, j ]
    
    if exc_is[1] < 1   exc_is[1] += num_units end
    if exc_is[2] < 1   exc_is[2] += num_units end

    fill_band!(T,j,exc_is,exc_val,inh_val)
  end

  T
end


function lagging_T( num_units, exc_val = 1, inh_val = -1, band_width = 1 )

  tT = typeof(exc_val) #type
  T = Array{tT,2}(num_units,num_units)

  for j in 1:num_units

    #bounds for the band
    exc_is = [ j, j + band_width ]

    if exc_is[1] > num_units  exc_is[1] -= num_units end
    if exc_is[2] > num_units  exc_is[2] -= num_units end

    fill_band!(T,j,exc_is,exc_val,inh_val)
  end

  T
end


function run_banded( num_time_steps = 30, num_units = 100,
                     exc_val = 5, inh_val = -1, band_width = 5 )
  T = banded_T(num_units, exc_val, inh_val, band_width)
  V = rand_V(num_units)

  p = plt.plot_line(V[:], true)
  show(p)

  println("Enter to continue")
  readline(STDIN)
  t = 0
  while t != num_time_steps

    print("\r Update #$t")
    sync_update!( V, T )
    plt.plot_line(V[:])
    sleep(0.01)

    t += 1
  end

  V, T
end


function continue_banded( V, T, num_time_steps = 100 )

  t = 0

  while t != num_time_steps
    print("\r Update #$t")
    sync_update!(V,T)
    plt.plot_line(V[:])
    sleep(0.01)

    t += 1
  end

  V,T
end


end #module end
