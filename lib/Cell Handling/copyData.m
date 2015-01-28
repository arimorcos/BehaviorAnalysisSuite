%copyData.m 

%function to get the data from the remote computer and reshape it 

%ASM 6/13/12

function [data] = copyData(path,tempName,reshapeSize,assignToBase,currentStoredData)

fileName = [path,tempName,'.dat'];
if ~exist(fileName) ~= 0
    data = 0;
    return;
end

%open connection to remote directory, copy data, and close connection
fclose('all');
fid = fopen(fileName);
try
    fseek(fid,currentStoredData*4,'bof');
    data = fread(fid,'float');
catch
    data = 0;
    return;
end
fclose(fid); 

%reshape data
data = reshape(data,reshapeSize,numel(data)/reshapeSize);
if assignToBase
    assignin('base','data',data);
end

end