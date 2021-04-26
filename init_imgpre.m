function string_image = init_imgpre(image)

[m, n, ~] = size(image); 
im = [];

if(size(size(image),2)>2)
   [m, n, mn] = size(image); 
    for mn_0 = 1:mn
        flat = reshape(image(:,:,mn_0)',[1 m*n]);
        im = [im,flat];
    end
else
im = reshape(image(:,:)',[1 m*n]);

end

string_image = num2str(im);     
string_image = string_image(~isspace(num2str(string_image)));

end