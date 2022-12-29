function J = my_parallel_axis(I,r, m)
%MY_PARALLEL_AXIS Summary of this function goes here
%   Detailed explanation goes here

J = I + m*(norm(r)^2*eye(3) - r * r');

% Source: https://www.physicsforums.com/threads/parallel-axis-theorem-and-interia-tensors.276083/

end

