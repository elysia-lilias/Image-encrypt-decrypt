function imhex = verify_sha256(filename,key)
if ~exist('key','var')
    key = 1;
end
strcmp = init_imgpre(filename);
strcmp = strcmp(1:1000+key);
sha256hasher = System.Security.Cryptography.SHA256Managed;           % Create hash object (?) - this part was copied from the forum post mentioned above, so no idea what it actually does


imageHash_uint8 = uint8(sha256hasher.ComputeHash(uint8(strcmp))); % Find uint8 of hash, outputs as a 1x32 uint8 array
%imageHash_uint8 = uint8(sha256hasher.ComputeHash(uint8( 'hex:5bfde92f992be9c3b4c4fa0adbb3af1cdcd10e464efc520cdceda97e37c011c45bfde92f992be9c3b4c4fa0adbb3af1cdcd10e464efc520cdceda97e37c011c45bfde92f992be9c3b4c4fa0adbb3af1cdcd10e464efc520cdceda97e37c011c45bfde92f992be9c3b4c4fa0adbb3af1cdcd10e464efc520cdceda97e37c011c45bfde92f992be9c3b4c4fa0adbb3af1cdcd10e464efc520cdceda97e37c011c45bfde92f992be9c3b4c4fa0adbb3af1cdcd10e464efc520cdceda97e37c011c45bfde92f992be9c3b4c4fa0adbb3af1cdcd10e464efc520cdceda97e37c011c45bfde92f992be9c3b4c4fa0adbb3af1cdcd10e464efc520cdceda97e37c011c45bfde92f992be9c3b4c4fa0adbb3af1cdcd10e464efc520cdceda97e37c011c45bfde92f992be9c3b4c4fa0adbb3af1cdcd10e464efc520cdceda97e37c011c45bfde92f992be9c3b4c4fa0adbb3af1cdcd10e464efc520cdceda97e37c011c45bfde92f992be9c3b4c4fa0adbb3af1cdcd10e464efc520cdceda97e37c011c4'))) 
imageHash_hex = dec2hex(imageHash_uint8) ;
imhex = string([8,1]);
for i=0:7
imhex(i+1) = convertCharsToStrings(imageHash_hex(4*i+1:4*(i+1),:)');
end
imhex = imhex';
end