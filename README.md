# Image-encrypt-decrypt
Image encrypt/decrypt based on chaos function and sha256 key
To save running time, use part of the image to get sha256 code
Besides, rather than generate a value by chaos function for each pixel, generate log10(numeber of pixels)+1 value
Then upset each 10 pixel based on first chaos value
Upset each 10 of "10 pixel" based on second chaos value
Upset each 10 of "100 pixel" based on third chaos value
....and so on
