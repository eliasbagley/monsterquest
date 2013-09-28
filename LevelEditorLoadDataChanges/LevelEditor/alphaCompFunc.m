% requres that these are all the same size, and merges A over B
function [result resultAlpha] = alphaCompFunc(A, Aalpha, B, Balpha)

% initialize so they are the right size
dim = size(A);
result = zeros(dim(1), dim(2), 3);
resultAlpha = zeros(dim(1), dim(2));

simp = (1-Aalpha(1:end,1:end));

resultAlpha(1:end,1:end) = Aalpha(1:end,1:end)+Balpha(1:end,1:end)-Aalpha(1:end,1:end).*Balpha(1:end,1:end);

result(1:end,1:end,1) = (A(1:end,1:end,1).*Aalpha(1:end,1:end) + B(1:end,1:end,1).*Balpha(1:end,1:end).*simp);%./resultAlpha(1:end,1:end);

result(1:end,1:end,2) = (A(1:end,1:end,2).*Aalpha(1:end,1:end) + B(1:end,1:end,2).*Balpha(1:end,1:end).*simp);%./resultAlpha(1:end,1:end);

result(1:end,1:end,3) = (A(1:end,1:end,3).*Aalpha(1:end,1:end) + B(1:end,1:end,3).*Balpha(1:end,1:end).*simp);%./resultAlpha(1:end,1:end);

end