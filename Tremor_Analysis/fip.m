function x = fip(a)
load HCTSA_N.mat
x = zeros(size(a));
for i = 1:40
    x(i)= find(Operations.ID == a(i));
end
x = reshape(x,1,40);