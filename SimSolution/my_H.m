function mat = my_H(vec)

mat = [eye(3), transpose(S_(vec));
zeros(3), eye(3)];

end
