%Kate Ju, Nick T
clc, clear all, clf


N=100; % number of units
T=100; % number of RW trajectories


pts = zeros(T,1);
c = rand(T,3);

hold on;

xlabel('N')
ylabel('B_j')

xlim([0,N])
ylim([-25,25])

for t = 1:N
    temp = rand(T,1);
    temp( temp < 0.25 ) = -1;
    temp( temp < 0.75 & temp >= 0.25) = 0;
    temp( temp >= 0.75 ) = 1;
    
    for i = 1:T
        line([t-1 t],[pts(i) pts(i)+temp(i)],'color',c(i,:));
    end
    
    pts = pts + temp;
    m = mean(pts);
    v = var(pts);
    new_title = sprintf('Random Walk - Mean = %f, Var = %f',m,v);
    title(new_title)
    drawnow;
    pause(0.0001);
    
end

