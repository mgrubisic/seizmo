function []=writeheader(data,varargin)
%WRITEHEADER    Write SEIZMO data header info to datafiles
%
%    Usage:    writeheader(data)
%              writeheader(data,...,'name',name,...)
%              writeheader(data,...,'prepend',string,...)
%              writeheader(data,...,'append',string,...)
%              writeheader(data,...,'delete',string,...)
%              writeheader(data,...,'delete',{str1 ... strN},...)
%              writeheader(data,...,'change',{original replacement},...)
%              writeheader(data,...,'path',path,...)
%              writeheader(data,...,'pathprepend',string,...)
%              writeheader(data,...,'pathappend',string,...)
%              writeheader(data,...,'pathdelete',string,...)
%              writeheader(data,...,'pathdelete',{str1 ... strN},...)
%              writeheader(data,...,'pathchange',{original replacemnt},...)
%              writeheader(data,...,'byteorder',endianness,...)
%
%    Description: WRITEHEADER(DATA) writes SEIZMO data headers as datafiles
%     on disk.  Primarily this is for updating the headers of existing
%     datafiles to match the SEIZMO DATA structure.
%
%     For options 'NAME', 'PREPEND', 'APPEND', 'DELETE', and 'CHANGE' see
%     CHANGENAME for usage.  For options 'PATH', 'PATHPREPEND',
%     'PATHAPPEND', 'PATHDELETE', and 'PATHCHANGE' see CHANGEPATH for
%     usage.  For option 'BYTEORDER' see CHANGEBYTEORDER for usage.
%
%    Notes:  
%     - If you want to modify the filetype, version or byte-order of
%       datafiles with SEIZMO, use READSEIZMO and WRITESEIZMO to read/write
%       the entire datafile so that the data can also be adjusted to the
%       new format.  Using READHEADER and WRITEHEADER in conjunction with a
%       filetype, version or byte-order change is NOT recommended as it
%       only changes the header and will likely corrupt your datafiles!
%     - Requires field LOVROK to be set to TRUE for overwriting.
%
%    Header changes: NONE
%
%    Examples:
%     Read in some datafile's headers, modify them, and write out changes:
%      writeheader(changeheader(readheader('A.SAC'),'kuser0','QCed'))
%
%    See also:  writeseizmo, readseizmo, bseizmo, readdatawindow, readdata,
%               readheader, seizmodef, getfileversion, changeheader,
%               getheader, listheader, getlgc, getenumid, getenumdesc

%     Version History:
%        Jan. 28, 2008 - initial version
%        Feb. 11, 2008 - new SACHP support, better checks
%        Mar.  4, 2008 - code cleaning, more checks, doc update
%        June 12, 2008 - doc update
%        Sep. 15, 2008 - history fix, doc update
%        Sep. 22, 2008 - blank name and endian handling
%        Sep. 26, 2008 - VINFO & NATIVEENDIAN added
%        Oct. 15, 2008 - new SEISCHK support (blank name and endian not
%                        allowed) => NATIVEENDIAN dropped
%        Oct. 17, 2008 - supports new struct layout, added CHKHDR support
%        Oct. 27, 2008 - update for struct changes, remove CHKHDR so user
%                        can write whatever they want to disk
%        Nov. 17, 2008 - update for new name schema (now WRITEHEADER)
%        Dec. 13, 2008 - added mkdir call to make sure path exists
%        Mar.  3, 2009 - update for GETFILEVERSION
%        Apr.  7, 2009 - LOVROK support, better messages/checks
%        Apr. 23, 2009 - fix nargchk for octave, move usage up
%        May  29, 2009 - allow options via WRITEPARAMETERS
%
%     Written by Garrett Euler (ggeuler at wustl dot edu)
%     Last Updated Aug. 17, 2009 at 20:45 GMT

% todo:

% check nargin
if(mod(nargin-1,2))
    error('seizmo:writeheader:badNumInputs',...
        'Bad number of arguments!');
end

% handle options
data=writeparameters(data,varargin{:});

% headers setup (checks struct too)
[h,vi]=versioninfo(data);

% turn off struct checking
oldseizmocheckstate=get_seizmocheck_state;
set_seizmocheck_state(false);

% get lovrok (fairly expensive)
lovrok=getlgc(data,'lovrok');

% loop over records
for i=1:numel(data)
    % construct fullname
    name=fullfile(data(i).path,data(i).name);
    
    % make sure directory exists
    [ok,msg,msgid]=mkdir(data(i).path);
    if(~ok)
        warning(msgid,msg);
        error('seizmo:writeheader:pathBad',...
            ['Record: %d, File: %s\n' ...
            'Cannot write record to path!'],i,name);
    end
    
    % open existing file for writing
    if(exist(name,'file'))
        % check lovrok
        if(strcmpi(lovrok(i),'false'))
            warning('seizmo:writeheader:lovrokBlock',...
                ['Record: %d, File: %s\n' ...
                'LOVROK set to FALSE!\n' ...
                'Cannot Overwrite ==> Skipping!'],i,name);
            continue;
        end
        
        % check if directory
        if(exist(name,'dir'))
            error('seizmo:writeheader:badFID',...
                ['Record: %d, File: %s\n' ...
                'File not openable for writing!\n'...
                '(Directory Conflict!)'],i,name);
        end
        
        % get version/byte-order of datafile on disk
        [filetype,fileversion,fileendian]=getfileversion(name);
        
        % non-zero version ==> file is SEIZMO compatible
        if(~isempty(filetype))
            % check for filetype/version/byte-order change
            if(filetype~=data(i).filetype)
                warning('seizmo:writeheader:filetypeMismatch',...
                    ['Record: %d, File: %s\n' ...
                    'Filetype of existing file does '...
                    'NOT match the output filetype!\n'...
                    'Data corruption is likely to occur!'],i,name);
            end
            if(fileversion~=data(i).version)
                warning('seizmo:writeheader:versionMismatch',...
                    ['Record: %d, File: %s\n' ...
                    'Version of existing file does ' ...
                    'NOT match output filetype version!\n' ...
                    'Data corruption is likely to occur!'],i,name);
            end
            if(fileendian~=data(i).byteorder)
                warning('seizmo:writeheader:endianMismatch',...
                    ['Record: %d, File: %s\n' ...
                    'Byte-order of existing file does '...
                    'NOT match output header byte-order!\n'...
                    'Data corruption is likely to occur!'],i,name);
            end
            
            % open file for modification
            fid=fopen(name,'r+',data(i).byteorder);
        % file exists but is not SEIZMO datafile
        else
            % SEIZMO is gonna trash your file!
            warning('seizmo:writeheader:badFile',...
                ['Record: %d, File: %s\n' ...
                'Existing file is not a SEIZMO datafile.\n' ...
                'Attempting to overwrite file...'],i,name);
            
            % overwrite file
            fid=fopen(name,'w',data(i).byteorder);
        end
    % file doesn't exist ==> make new file
    else
        % new file
        fid=fopen(name,'w',data(i).byteorder);
    end
    
    % check fid
    if(fid<0)
        % unopenable file for writing (permissions?)
        error('seizmo:writeheader:badFID',...
            ['Record: %d, File: %s\n' ...
            'File not openable for writing!\n'...
            '(Permissions problem?)'],i,name);
    end
    
    % fill header with dummy bytes (so we can seek around)
    fseek(fid,0,'bof');
    count=fwrite(fid,zeros(h(vi(i)).data.startbyte,1),'char');
    
    % verify write
    if(count<h(vi(i)).data.startbyte)
        % write failed
        fclose(fid);
        error('seizmo:writeheader:writeFailed',...
            'Record: %d, File: %s\nWriting failed!',i,name);
    end
    
    % write header
    n=h(vi(i)).types;
    for m=1:length(n)
        for k=1:length(h(vi(i)).(n{m}))
            fseek(fid,h(vi(i)).(n{m})(k).startbyte,'bof');
            fwrite(fid,data(i).head(h(vi(i)).(n{m})(k).minpos:...
                h(vi(i)).(n{m})(k).maxpos),h(vi(i)).(n{m})(k).store);
        end
    end
    
    % close file
    fclose(fid);
end

% toggle checking back
set_seizmocheck_state(oldseizmocheckstate);

end
