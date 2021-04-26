function recover = decode(imagenew,key)
if ~exist('key','var')
    key = 0;
    if(key == '')
        key = 0;
    end
example = matfile('key.mat');
try
H = example.H;
catch me
    H = init_sha("not found");
end
else
key = sum(hex2dec(reshape(char(init_sha(key)),[64,1])));
H = init_sha(key);    
end


sized = prod(size(imagenew));
idx = init_chaos_log(sized,H);


az = encode_r(idx,sized,10);
recover = zeros(1,sized);
recover = reshape(recover,[],1);

idx = az-(min(az))+1;
idx = (idx(idx<=sized));
for i=1:prod(sized)
    recover(idx(i)) = imagenew(i);
end

recover = uint8(reshape(recover,size(imagenew)));
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