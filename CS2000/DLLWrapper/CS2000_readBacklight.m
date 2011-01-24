function message = CS2000_readBacklight()
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
global s 

fprintf(s, 'BALR');

% Get instrument answer into file:
answer = fscanf(s);
    
fid = fopen('Temp\answers.tmp', 'w');
fprintf(fid, answer);
fclose(fid);
    
% Get instrument error-check code:
fid = fopen('Temp\answers.tmp','r');
ErrorCheckCode = fscanf(fid,'%c',4);
[tf, errOutput] = CS2000_errMessage(ErrorCheckCode);

if tf ~= 1
    blnorm = errOutput; 
    blmeas = ' ';
end
    
% Get backlight settings:
if tf == 1 
    garbage = fscanf(fid, '%c',1);
    blnorm = fscanf(fid, '%c',1);
    garbage = fscanf(fid, '%c',1);
    blmeas = fscanf(fid, '%c',1);
    switch blnorm
        case '0'
            stat = 'off';
        case '1' 
            stat = 'on';
        otherwise
            stat = 'Error';
    end    
    
    switch blmeas 
        case '0'
            all = 'off';
        case '1'
            all = 'on';
        otherwise
            all = 'error';
    end
    message = ['Backlight has been set �', all,...
        '� during measurement.'];
    disp(message);
end  

fclose(fid);

end
