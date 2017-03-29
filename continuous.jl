#!/usr/bin/env julia

module continuous

lambda = 1.4
T = [0 1; 1 0];

g(u) = (2/pi)*atan(pi*lambda*u/2)
dVdu(u,l) = l/(1+(l*pi*u/2)^2)
ginv(V,l) = tan(V*(pi/2))*2/(pi*l)
intginv(V,l) = -log(abs(cos(V*pi/2)))*4/(pi^2*l)

function flow_field2d(inc, lambda=lambda)

  eval_points = -1:inc:1

  grid_shape = (length(eval_points),length(eval_points))

  dV1dt = zeros(grid_shape); dV2dt = zeros(grid_shape)
  E = zeros(grid_shape)

  V1, V2 = zeros(grid_shape), zeros(grid_shape)

  for (i,v1) in enumerate(eval_points), (j,v2) in enumerate(eval_points)

    u1 = ginv(v1,lambda); u2 = ginv(v2,lambda)

    #T12 == T21 == 1, R absorbed into lambda?
    #println("dVdu: $(dVdu(u1,lambda)), v2: $v2, u1: $u1")#debug
    dV1dt[i,j] = dVdu(u1,lambda)*(v2 - u1)
    dV2dt[i,j] = dVdu(u2,lambda)*(v1 - u2)

    E[i,j] = -v1*v2 + lambda*intginv(v1,lambda) + lambda*intginv(v2,lambda)

    V1[i,j] = v1; V2[i,j] = v2
  end

  dV1dt, dV2dt, V1, V2, E
end


end #module end
