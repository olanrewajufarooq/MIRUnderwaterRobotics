function C = divMat(A,B)
%DIVMAT Summary of this function goes here
%   Detailed explanation goes here
C = zeros(size(A));

for j = 1:size(A, 2)
    for i = 1:size(A, 1)

        if A(i, j) == 0
            C(i, j) = 0;
            continue
        end

        C(i, j) = A(i, j)/B(i, j);

    end
end

end

