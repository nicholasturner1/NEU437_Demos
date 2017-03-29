module plotting

# General plotting, though fns specific to plotting
# specific types of data reside within the modules
# for that type

using PyPlot


function plot_heatmap(V, new_fig=false, flip=false)

  side_len = round(Int,sqrt(size(V,1)))

  @assert side_len * side_len == prod(size(V))

  z = reshape(V,(side_len,side_len))

  if flip z = z[end:-1:1,:] end

  #PyPlot.imshow(1:side_len, 1:side_len, z, aspect_ratio=1,show=true)
  if new_fig PyPlot.figure() end

  PyPlot.pcolormesh(z)
end


plot_flowfield(Xcomp, Ycomp, Xloc, Yloc) = PyPlot.quiver(Xloc, Yloc, Xcomp, Ycomp)


function plot_line(X, new_fig=false)

  if   new_fig PyPlot.figure()
  else PyPlot.clf()
  end

  xlim(0,length(X)-1)
  ylim(0,2)
  xlabel("Unit")
  ylabel("Activation")
  plot(X)
end
  

end #module end
