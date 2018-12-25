function res = PadLeftRight(img)
    res = uint8(zeros(224,256,3));
    res(:,17:240,:) = img;
end