function [data]=idft(data)
%IDFT    Performs an inverse discrete fourier transform on SAClab records
%
%    Description: IDFT(DATA) converts SAClab records from the frequency 
%     domain to the time domain using an inverse discrete fourier transform
%     (Matlab's ifft).  Output filetype is 'Time Series File'.
%
%    Notes:
%     - SAC (and thus SAClab's DFT for sanity) calculates spectral data 
%       according to Parseval's theorem.  This is not equivalent to how
%       Matlab's fft/ifft functions work so be careful when working with
%       amplitudes!
%
%    System requirements: Matlab 7
%
%    Header Changes: B, SB, E, DELTA, SDELTA, NPTS, NSPTS
%                    DEPMEN, DEPMIN, DEPMAX
%     In the frequency domain B, DELTA, and NPTS are changed to the 
%     beginning frequency, sampling frequency, and number of data points in
%     the transform (includes negative frequencies).  The original values 
%     of B, DELTA, and NPTS are saved in the header as SB, SDELTA, and 
%     NSNPTS and are restored when this command is performed.
%
%    Usage:    data=idft(data)
%
%    Examples:
%     To take the derivative of a time-series in the frequency domain:
%      data=idft(mulomega(dft(data)))
%
%    See also: dft, amph2rlim, rlim2amph, divomega, mulomega

%     Version History:
%        Jan. 28, 2008 - initial version
%        Feb. 28, 2008 - seischk support and code cleanup
%        Mar.  2, 2008 - readibility change
%        Mar.  3, 2008 - now compatible with SAC
%        Mar.  4, 2008 - cleaned up errors and warnings
%        May  12, 2008 - name changed to idft
%        June 11, 2008 - added example
%        July 19, 2008 - doc update, .dep rather than .x, dataless support,
%                        one ch call, updates DEP* fields
%        Oct.  7, 2008 - minor code cleaning
%
%     Written by Garrett Euler (ggeuler at wustl dot edu)
%     Last Updated Oct.  7, 2008 at 02:05 GMT

% todo:

% check nargin
error(nargchk(1,1,nargin))

% check data structure
error(seischk(data,'dep'))

% retreive header info
leven=glgc(data,'leven');
iftype=genumdesc(data,'iftype');
[b,delta,sb,sdelta,npts,nspts]=...
    gh(data,'b','delta','sb','sdelta','npts','nspts');
e=sb+(nspts-1).*sdelta;

% check leven,iftype
if(any(~strcmpi(leven,'true')))
    error('SAClab:idft:illegalOperation',...
        'Illegal operation on unevenly spaced record!');
elseif(any(~strcmpi(iftype,'Spectral File-Real/Imag')...
        & ~strcmpi(iftype,'Spectral File-Ampl/Phase')))
    error('SAClab:idft:illegalOperation',...
        'Illegal operation on non-spectral file!');
end

% loop through records
depmen=nan(nrecs,1); depmin=depmen; depmax=depmen;
for i=1:numel(data)
    % skip dataless
    if(isempty(data(i).dep)); continue; end
    
    % save class and convert to double precision
    oclass=str2func(class(data(i).dep));
    data(i).dep=double(data(i).dep);
    
    % turn back into time domain
    if(strcmpi(iftype(i),'Spectral File-Real/Imag'))
        data(i).dep=1/sdelta(i)*ifft(...
            complex(data(i).dep(:,1:2:end),data(i).dep(:,2:2:end)),...
            'symmetric');
    else
        data(i).dep=1/sdelta(i)*ifft(...
            data(i).dep(:,1:2:end).*exp(j*data(i).dep(:,2:2:end)),...
            'symmetric');
    end
    
    % truncate to original length and change class back
    data(i).dep=oclass(data(i).dep(1:nspts(i),:));
    
    % dep*
    depmen(i)=mean(data(i).dep(:)); 
    depmin(i)=min(data(i).dep(:)); 
    depmax(i)=max(data(i).dep(:));
end

% update header (note there is no field 'se')
data=ch(data,'b',sb,'e',e,'delta',sdelta,'sb',b,...
    'sdelta',delta,'nspts',npts,'npts',nspts,'iftype','Time Series File',...
    'depmen',depmen,'depmin',depmin,'depmax',depmax);

end