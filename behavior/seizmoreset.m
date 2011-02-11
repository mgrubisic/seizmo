function []=seizmoreset(varargin)
%SEIZMORESET    Resets saved SEIZMO settings
%
%    Usage:    seizmoreset()
%              seizmoreset(option1,...,optionN)
%
%    Description: SEIZMORESET() clears all saved SEIZMO settings.  This
%     includes all changes made with CHECKOPERR, BINOPERR, etc as well as
%     any cached info (like from SEIZMODEF).  Useful for putting SEIZMO in
%     its default state.
%
%     SEIZMORESET(OPTION1,...,OPTIONN) clears specific SEIZMO settings
%     based on OPTION1 to OPTIONN.  OPTION must be a string with one of the
%     following values:
%      'all'        - clears all SEIZMO settings (same as SEIZMORESET())
%      'checks'     - resets CHECKHEADER/SEIZMOCHECK states
%
%    Notes:
%
%    Examples:
%     Most SEIZMO functions alter the state of SEIZMOCHECK & CHECKHEADER to
%     speed up operations.  When an error in these functions occurs, the 
%     state of SEIZMOCHECK & CHECKHEADER are not properly set back to the
%     previous state.  A workaround is to reset checking after the error:
%      seizmoreset('checks')
%
%    See also: SET_SEIZMOCHECK_STATE, SET_CHECKHEADER_STATE

%     Version History:
%        Oct.  7, 2009 - initial version
%
%     Written by Garrett Euler (ggeuler at wustl dot edu)
%     Last Updated Oct.  7, 2009 at 20:00 GMT

% todo:

% get SEIZMO global
global SEIZMO

% implement specific options
if(nargin)
    if(~iscellstr(varargin))
        error('seizmo:seizmoreset:badInput','OPTION must be a string!')
    end
    for i=1:nargin
        switch lower(varargin{i})
            case {'all' ''}
                clear global SEIZMO
            case 'checks'
                SEIZMO.SEIZMOCHECK=rmfield(SEIZMO.SEIZMOCHECK,'ON');
                SEIZMO.CHECKHEADER=rmfield(SEIZMO.CHECKHEADER,'ON');
            otherwise
                error('seizmo:seizmoreset:badOption',...
                    'OPTION unknown: %s',varargin{i});
        end
    end
else
    % 'all'
    clear global SEIZMO
end

end