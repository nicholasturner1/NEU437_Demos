#!/usr/bin/env julia


module plotting

using PyPlot


function plot_heatmap(V, new_fig=false)

  side_len = round(Int,sqrt(size(V,1)))

  @assert side_len * side_len == prod(size(V))

  z = reshape(V,(side_len,side_len))

  #PyPlot.imshow(1:side_len, 1:side_len, z, aspect_ratio=1,show=true)
  if new_fig PyPlot.figure() end

  PyPlot.pcolormesh(z)
end


end #module end
