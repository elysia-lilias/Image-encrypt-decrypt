function imnew = encode(im,key)
if ~exist('key','var')
    key = 0;
    if(key == '')
        key = 0;
    end
[H,key] = init_sha(im,key);
save('key.mat','H');
else
key = sum(hex2dec(reshape(char(init_sha(key)),[64,1])));
H = init_sha(key);    
end

sized = prod(size(im));
idx = init_chaos_log(sized,H);

az = encode_r(idx,sized,10);
az = az-(min(az))+1;
imnew = reshape(im(az(az<=sized)),size(im));
end

function am = encode_r(idx,sized2,level)
if level*10 >= sized2
ii = log10(level);
sized = ceil(sized2/level);
am = repmat(idx(:,ii)',sized,1);
az = 0:sized-1;
az = (repmat(az,10,1)'*10);
am = am + az;
am = am';
am = am(:)';
else
  ii = log10(level);
az = encode_r(idx,sized2,level*10);
az = (repmat(az,10,1)'*10);
sized = size(az,1);
am = repmat(idx(:,ii)',sized,1);

am = am + az;
am = am';  
am = am(:)';    
end

end