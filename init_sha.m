function [H,key] = init_sha(image,key)
if ~exist('key','var')
    key = 1;
end
%% constants 
h0 = 0x6a09e667;
h1 = 0xbb67ae85;
h2 = 0x3c6ef372;
h3 = 0xa54ff53a;
h4 = 0x510e527f;
h5 = 0x9b05688c;
h6 = 0x1f83d9ab;
h7 = 0x5be0cd19;

H = [h0; h1; h2; h3; h4; h5; h6; h7];
H = de2bi(H,32,'left-msb');

const = [  0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
   0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
   0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
   0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
   0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
   0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
   0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
   0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
];
const = const';



%% Get string value of image
strtmp = init_imgpre(image);



strtmp = strtmp(1:min(1000+key,length(strtmp)));

im_bin =  de2bi(double(strtmp),8,'left-msb');


sizeim = prod(size(im_bin));
tmp1 = floor(sizeim/512);
tmp2 = tmp1*512 + 448;
diff = tmp2 - sizeim;
if(diff == 0)
    diff = 512;
end
appendmat = zeros(1,diff);
appendmat(1) = 1;

%% append 1000....000 to the last make size mod 512 = 448
%apend size as 64 bit binary number
im_bin2 = [im_bin;reshape(appendmat,[diff/8,8]);reshape(de2bi(sizeim,64,'left-msb'),[8,8])'];

im_bin2 = im_bin2';
im_bin2 = reshape(im_bin2,[512,tmp1+1]);
im_bin2 = im_bin2';

waitb = waitbar(0,'please wait');

%% start updating
for ii=1:tmp1+1
    wb = tmp1+1;
    %for each chunk (512 bit)
    str=['SHA256 running...',num2str(ii/wb*100),'%'];
    waitbar(ii/wb,waitb, str)
    chunk = im_bin2(ii,:);
    %get 1~16th word from chunk
    w = reshape(chunk,[32,16])';
    
    %calculate 17~60th word
    for wordappend = 17:64
        s0 = xor(circshift(w(wordappend-15,:),7),circshift(w(wordappend-15,:),18));
        t = circshift(w(wordappend-15,:),3);
        t(1:3) = [0 0 0];
        s0 = xor(s0,t);
        
        s1 = xor(circshift(w(wordappend-2,:),17),circshift(w(wordappend-2,:),19));
        t = circshift(w(wordappend-2,:),10);
        t(1:10) = [0 0 0 0 0 0 0 0 0 0];
        s1 = xor(s1,t);
        
        sw_1 = bin2dec(num2str(w(wordappend-16,:)));
        sw_2 = bin2dec(num2str(s0));
        sw_3 = bin2dec(num2str(w(wordappend-7,:)));
        sw_4 = bin2dec(num2str(s1));
        
       sw = sw_1 + sw_2 + sw_3 + sw_4;
       sw = mod(sw,2^32);
       sw = de2bi(sw,32,'left-msb');
        w = [w;sw];
    end
    
   
    a = H(1,:);
    b = H(2,:);
    c = H(3,:);
    d = H(4,:);
    e = H(5,:);
    f = H(6,:);
    g = H(7,:);
    h = H(8,:);
    
    %for each word 
    for i = 1:64
       
        
        tmps1 = xor(circshift(a,2),circshift(a,13));
        tmps1 = xor(circshift(a,22),tmps1);
        
        tmps2 = xor((a & b),(a & c));
        tmps2 = xor((b & c),tmps2);
        
      
        tp_1 = bin2dec(num2str(tmps1));
        tp_2 = bin2dec(num2str(tmps2));

        fin2 =mod(tp_1+tp_2, 2^32);
      
        tmps3 = xor(circshift(e,6),circshift(e,25));
        tmps3 = xor(circshift(e,11),tmps3);
        
        tmps4 = xor((e & f),(~e & g));
        
        tp_3 = bin2dec(num2str(tmps3));
        tp_4 = bin2dec(num2str(tmps4));
        w_i =  bin2dec(num2str(w(i,:)));
        hh = bin2dec(num2str(h));
       
        fin1 = hh + tp_3 + tp_4 + double(const(i)) + w_i;
        fin1 = mod(fin1,2^32);
   
        %update a~h    
        h = g;
        g = f;
        f = e;
           e_d = bin2dec(num2str(d));
           e = mod(e_d + fin1,2^32);
        e = de2bi(e,32,'left-msb');
        d = c;
        c = b;
        b = a;
           a = mod(fin2 + fin1,2^32);
        a = de2bi(a,32,'left-msb');
        
        
    end
    %update h0~h7
    all_hash = [a;b;c;d;e;f;g;h];
            hash_i = bin2dec(num2str(all_hash));
            hash_h = bin2dec(num2str(H));
            hash_res = hash_i + hash_h;
            H = de2bi(mod(hash_res,2^32),32,'left-msb');
end
close(waitb);
H = binaryVectorToHex(H);
end
