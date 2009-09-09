function [data]=recordfun(fun,varargin)
%RECORDFUN    Perform basic function between SEIZMO records
%
%    Usage:    data=recordfun(fun,data)
%              data=recordfun(fun,data1,data2)
%              data=recordfun(fun,data1,data2,...,dataN)
%              data=recordfun(...,'newhdr',true|false)
%              data=recordfun(...,'npts',...
%                  'error'|'warn'|'truncate'|'pad'|'ignore')
%              data=recordfun(...,'ncmp',...
%                  'error'|'warn'|'truncate'|'pad'|'ignore')
%              data=recordfun(...,'delta','error'|'warn'|'ignore')
%              data=recordfun(...,'begin','error'|'warn'|'ignore')
%              data=recordfun(...,'ref','error'|'warn'|'ignore')
%              data=recordfun(...,'leven','error'|'warn'|'ignore')
%              data=recordfun(...,'iftype','error'|'warn'|'ignore')
%
%    Description: RECORDFUN(FUN,DATA) operates on all records in DATA using
%     FUN and will return a single record with its header fields set to
%     those of the first record in DATA.  FUN must be either '+', '-', '/',
%     '*', or a function handle.  The '+', '-', '/','*' options all operate
%     on the records point by point.  Function handles must accept 2
%     numeric arrays and return 1 numeric array.  The returned header can
%     be that of the last record by setting option 'newhdr' to TRUE.
%     Records should be of the same filetype, be evenly sampled, have the
%     same sample rate, number of points, and timing but these can all be
%     ignored (for better or for worse) by setting options available in
%     BINOPERR to 'ignore'.
%     
%     RECORDFUN(FUN,DATA1,DATA2) operates between the records in DATA1 and
%     DATA2, returning a dataset of the same size.  If either DATA1 or
%     DATA2 are a single record, the record will be replicated to operate
%     on every record of the other dataset.  DATA1 and DATA2 must contain
%     the same number of records otherwise.
%     
%     RECORDFUN(FUN,DATA1,DATA2,...,DATAN) operates on the records in all N
%     datasets such that the first record of each dataset are operated on
%     together and so on.  Therefore every dataset must have the same
%     number of records.  The exception to this rule is single record
%     datasets, which are replicated to match the size of the rest of the
%     datasets.
%     
%     RECORDFUN(...,'newhdr',true) controls the inheritance of header
%     fields and will set the resultant records' header fields to those of
%     the last record to be added on.  So
%                    RECORDFUN(FUN,DATA1,DATA2,'newhdr',true)
%     will produce records with header fields set to those in DATA2.  By
%     default 'newhdr' is set to FALSE which sets the resultant records'
%     header fields to those in DATA1.  If adding all records in a single
%     dataset, setting 'newhdr' to TRUE will set the resultant record's
%     header equal to the last record's header.  Leaving 'newhdr' set to
%     the default FALSE will set the resultant record's header to that of
%     the first record's header.
%     
%     *********************************************************
%     The following options may also be controlled by BINOPERR.
%     *********************************************************
%     
%     RECORDFUN(...,'npts','error|warn|truncate|pad|ignore') sets the
%     reaction to records with different numbers of points.  If the option
%     is set to 'warn' or 'ignore', the number of points in the records is
%     not altered - which will likely cause an error during the operation.
%     If the option is set to 'truncate', the number of points in the
%     records being operated on will be equal to that with the least.
%     Option 'pad' will make the records being operated on have number of
%     points equal to that with the most (note that padding is done with
%     zeros).  By default 'npts' is set to 'error'.
%     
%     RECORDFUN(...,'ncmp','error|warn|truncate|pad|ignore') sets the
%     reaction to records with different numbers of components.  If the
%     option is set to 'warn' or 'ignore', the number of components in the
%     records is not altered - which will likely lead to an error.  If the
%     option is set to 'truncate', the number of components in the records
%     being operated on will be equal to that with the least.  Option 'pad'
%     will make the number of components for records in the operation equal
%     to that of the record with the most (note that padding is done with
%     zeros).  By default 'ncmp' is set to 'error'.
%     
%     RECORDFUN(...,'delta','error|warn|ignore') sets the reaction to
%     records with different sample rates.  If the option is set to 'warn'
%     or 'ignore', the records are just operated on point for point
%     (basically ignoring timing).  The resultant records' sample rates are
%     determined by the parent of their header fields (set by option
%     'newhdr').  By default 'delta' is set to 'error'.
%     
%     RECORDFUN(...,'begin','error|warn|ignore') sets the reaction to
%     records with different begin times.  If the option is set to 'warn'
%     or 'ignore', the resultant records' begin times are determined by the
%     parent of their header fields (set by option 'newhdr').  By default
%     'begin' is set to 'warn'.
%     
%     RECORDFUN(...,'ref','error|warn|ignore') sets the reaction to
%     records with different reference times.  If the option is set to
%     'warn' or 'ignore', the resultant records' reference times are
%     determined by the parent of their header fields (set by option
%     'newhdr').  By default 'ref' is set to 'warn'.
%     
%     RECORDFUN(...,'leven','error|warn|ignore') sets the reaction to
%     unevenly sampled records.  If the option is set to 'warn' or
%     'ignore', the records are just operated on point for point (basically
%     ignoring timing).  The resultant records' leven fields are determined
%     by the parent of their header fields (set by option 'newhdr').  By
%     default 'leven' is set to 'error'.
%     
%     RECORDFUN(...,'iftype','error|warn|ignore') sets the reaction to
%     records of different types.  If the option is set to 'warn' or
%     'ignore', the records are just operated on point for point.  The 
%     resultant records' iftypes are determined by the parent of their
%     header fields (set by option 'newhdr').  By default 'iftype' is set
%     to 'warn'.
%     
%    Notes:
%     
%    Header changes: DEPMIN, DEPMAX, DEPMEN,
%     NPTS, NCMP (see option 'npts' and 'ncmp')
%     See option 'newhdr' for inheritance of other header fields.
%
%    Examples:
%     Display a stack of the records:
%      plot1(recordfun('+',data))
%     
%     Add records from one dataset to another
%      data=recordfun('+',data1,data2)
%     
%    See also: addrecords, subtractrecords, multiplyrecords, dividerecords,
%              binoperr, seizmofun, joinrecords

%     Version History:
%        June 10, 2008 - initial version
%        June 11, 2008 - full filetype and class support
%        June 20, 2008 - doc update, 'ncmp' option
%        June 28, 2008 - fixed amph2rlim handling, doc update,
%                        .dep and .ind rather than .x and .t
%        Oct.  6, 2008 - doc update, code clean, more checks
%        Nov. 23, 2008 - combined code of basic functions to centralize
%                        and reduce code
%        Apr. 23, 2009 - move usage up
%        June  8, 2009 - force column-vector data
%        June 12, 2009 - ISSEIZMO now overrides setting SEIZMOCHECK off
%                        by default, so remove setting SEIZMOCHECK state
%        June 24, 2009 - now adds iamph files directly
%        June 28, 2009 - now accepts function handles, additional methods
%                        for different npts/ncmp, lots of code refactoring
%        Aug. 21, 2009 - changed IFTYPE from ERROR to WARN to allow working
%                        with mixed xy and timeseries data
%
%     Written by Garrett Euler (ggeuler at wustl dot edu)
%     Last Updated Aug. 21, 2009 at 21:25 GMT

% todo:

% default options
option.NEWHDR=false;
option.NPTS='ERROR';
option.DELTA='ERROR';
option.BEGIN='WARN';
option.REF='WARN';
option.NCMP='ERROR';
option.LEVEN='ERROR';
option.IFTYPE='WARN';

% available states
valid.NPTS={'ERROR' 'WARN' 'TRUNCATE' 'PAD' 'IGNORE'};
valid.NCMP={'ERROR' 'WARN' 'TRUNCATE' 'PAD' 'IGNORE'};
valid.REF={'ERROR' 'WARN' 'IGNORE'};
valid.DELTA={'ERROR' 'WARN' 'IGNORE'};
valid.BEGIN={'ERROR' 'WARN' 'IGNORE'};
valid.LEVEN={'ERROR' 'WARN' 'IGNORE'};
valid.IFTYPE={'ERROR' 'WARN' 'IGNORE'};

% get options set by BINOPERR (SEIZMO global)
global SEIZMO; fields=fieldnames(option).';
if(isfield(SEIZMO,'BINOPERR'))
    for i=fields
        if(isfield(SEIZMO.BINOPERR,i{:}))
            if(strcmpi('NEWHDR',i{:}))
                try
                    option.(i{:})=logical(SEIZMO.BINOPERR.(i{:})(1));
                catch
                    warning('seizmo:recordfun:badState',...
                        '%s in unknown state => changed to default!',i{:});
                    SEIZMO.BINOPERR.(i{:})=option.(i{:});
                end
            else
                if(~any(strcmpi(SEIZMO.BINOPERR.(i{:}),valid.(i{:}))))
                    warning('seizmo:recordfun:badState',...
                        '%s in unknown state => changed to default!',i{:});
                    SEIZMO.BINOPERR.(i{:})=option.(i{:});
                else
                    option.(i{:})=upper(SEIZMO.BINOPERR.(i{:}));
                end
            end
        end
    end
end

% check function
if(~isscalar(fun) || ((~ischar(fun) ...
        && ~any(strcmpi(fun,{'+' '-' '/' '*'}))) ...
        && ~isa(fun,'function_handle')))
    error('seizmo:recordfun:badFUN',...
        'FUN must be ''+'' ''-'' ''/'' ''*'' or a function handle!');
end
if(ischar(fun))
    % cannot use str2func to build anonymous functions
    % without throwing a warning...so manually doing it
    switch fun
        case '+'
            fun=@(x,y)(x+y);
        case '-'
            fun=@(x,y)(x-y);
        case '*'
            fun=@(x,y)(x.*y);
        case '/'
            fun=@(x,y)(x./y);
    end
end

% find all datasets in inline arguments
isdata=false(1,nargin-1);
for i=1:(nargin-1); isdata(i)=isseizmo(varargin{i},'dep'); end

% turn off struct checking
oldseizmocheckstate=get_seizmocheck_state;
set_seizmocheck_state(false);

% push datasets into a separate variable
data=varargin(isdata);
varargin(isdata)=[];

% options must be field-value pairs
nargopt=numel(varargin);
if(mod(nargopt,2))
    error('seizmo:recordfun:badNumOptions','Unpaired option(s)!');
end

% get inline options
for i=1:2:nargopt
    varargin{i}=upper(varargin{i});
    if(isfield(option,varargin{i}))
        if(strcmpi('NEWHDR',varargin{i}))
            try
                option.(varargin{i})=logical(varargin{i+1}(1));
            catch
                warning('seizmo:recordfun:badState',...
                    '%s state bad => leaving alone!',varargin{i});
            end
        else
            if(~any(strcmpi(varargin{i+1},valid.(varargin{i}))))
                warning('seizmo:recordfun:badState',...
                    '%s state bad => leaving alone!',varargin{i});
            else
                option.(varargin{i})=upper(varargin{i+1});
            end
        end
    else
        warning('seizmo:recordfun:badInput',...
            'Unknown Option: %s !',varargin{i}); 
    end
end

% get number of records in each dataset
ndatasets=numel(data);
nrecs=zeros(1,ndatasets);
for i=1:ndatasets
    nrecs(i)=numel(data{i});
end

% check for bad sized datasets
maxrecs=max(nrecs);
if(any(nrecs~=1 & nrecs~=maxrecs))
    error('seizmo:recordfun:nrecsMismatch',...
        'Number of records in datasets inconsistent!');
end

% expand scalar datasets
for i=find(nrecs==1)
    data{i}(1:maxrecs,1)=data{i};
end

% check and get header fields
b(1:ndatasets)={nan(maxrecs,1)};
npts=b; delta=b; leven=b; iftype=b; ncmp=b;
nzyear=b; nzjday=b; nzhour=b; nzmin=b; nzsec=b; nzmsec=b;
for i=1:ndatasets
    data{i}=checkheader(data{i});
    ncmp{i}=getncmp(data{i});
    leven{i}=getlgc(data{i},'leven');
    iftype{i}=getenumdesc(data{i},'iftype');
    [npts{i},delta{i},b{i},nzyear{i},nzjday{i},...
        nzhour{i},nzmin{i},nzsec{i},nzmsec{i}]=...
        getheader(data{i},'npts','delta','b',...
        'nzyear','nzjday','nzhour','nzmin','nzsec','nzmsec');
end

% turn off header checking
oldcheckheaderstate=get_checkheader_state;
set_checkheader_state(false);

% 2+ datasets
if(ndatasets>1)
    % check records
    if(~isequal(iftype{:}))
        report.identifier='seizmo:recordfun:mixedIFTYPE';
        report.message='Filetypes differ for some records!';
        if(strcmpi(option.IFTYPE,'error'))
            error(report);
        elseif(strcmpi(option.IFTYPE,'warn'))
            warning(report.identifier,report.message);
        end
    end
    for i=1:ndatasets
        if(any(~strcmpi(leven{i},'true')))
            report.identifier='seizmo:recordfun:illegalOperation';
            report.message='illegal operation on unevenly spaced record!';
            if(strcmpi(option.LEVEN,'error'))
                error(report);
            elseif(strcmpi(option.LEVEN,'warn'))
                warning(report.identifier,report.message);
            end
        end
    end
    if(~isequal(ncmp{:}))
        report.identifier='seizmo:recordfun:mixedNCMP';
        report.message='Number of components differ for some records!';
        if(strcmpi(option.NCMP,'error'))
            error(report);
        elseif(strcmpi(option.NCMP,'warn'))
            warning(report.identifier,report.message);
        end
    end
    if(~isequal(npts{:}))
        report.identifier='seizmo:recordfun:mixedNPTS';
        report.message='Number of points differ for some records!';
        if(strcmpi(option.NPTS,'error'))
            error(report);
        elseif(strcmpi(option.NPTS,'warn'))
            warning(report.identifier,report.message);
        end
    end
    if(~isequal(delta{:}))
        report.identifier='seizmo:recordfun:mixedDELTA';
        report.message='Sample rates differ for some records!';
        if(strcmpi(option.DELTA,'error'))
            error(report);
        elseif(strcmpi(option.DELTA,'warn'))
            warning(report.identifier,report.message);
        end
    end
    if(~isequal(b{:}))
        report.identifier='seizmo:recordfun:mixedB';
        report.message='Begin times differ for some records!';
        if(strcmpi(option.BEGIN,'error'))
            error(report);
        elseif(strcmpi(option.BEGIN,'warn'))
            warning(report.identifier,report.message);
        end
    end
    if(~isequal(nzyear{:}) || ~isequal(nzjday{:}) ...
            || ~isequal(nzhour{:}) || ~isequal(nzmin{:}) ...
            || ~isequal(nzsec{:})  || ~isequal(nzmsec{:}))
        report.identifier='seizmo:recordfun:mixedReferenceTimes';
        report.message='Reference times differ for some records!';
        if(strcmpi(option.REF,'error'))
            error(report);
        elseif(strcmpi(option.REF,'warn'))
            warning(report.identifier,report.message);
        end
    end
    
    % save class and convert to double precision
    oclass=cell(1,maxrecs);
    if(option.NEWHDR)
        for i=1:maxrecs; oclass{i}=str2func(class(data{end}(i).dep)); end
    else
        for i=1:maxrecs; oclass{i}=str2func(class(data{1}(i).dep)); end
    end
    for i=1:ndatasets
        for j=1:maxrecs; data{i}(j).dep=double(data{i}(j).dep); end
    end
    
    % alter size of npts/ncmp
    allnpts=cell2mat(npts);
    allncmp=cell2mat(ncmp);
    if(strcmpi(option.NPTS,'TRUNCATE'))
        minpts=min(allnpts,[],2);
        for i=1:ndatasets
            for j=1:maxrecs
                data{i}(j).dep=data{i}(j).dep(1:minpts(j),:);
            end
        end
    elseif(strcmpi(option.NPTS,'PAD'))
        maxpts=max(allnpts,[],2);
        for i=1:ndatasets
            for j=1:maxrecs
                data{i}(j).dep=[data{i}(j).dep;
                    zeros(maxpts(j)-npts{i}(j),ncmp{i}(j))];
            end
        end
    end
    if(strcmpi(option.NCMP,'TRUNCATE'))
        mincmp=min(allncmp,[],2);
        for i=1:ndatasets
            for j=1:maxrecs
                data{i}(j).dep=data{i}(j).dep(:,1:mincmp(j));
            end
        end
    elseif(strcmpi(option.NCMP,'PAD'))
        maxcmp=max(allncmp,[],2);
        for i=1:ndatasets
            for j=1:maxrecs
                data{i}(j).dep=[data{i}(j).dep ...
                    zeros(npts{i}(j),maxcmp(j)-ncmp{i}(j))];
            end
        end
    end
    
    % operate on records
    npts=nan(maxrecs,1); ncmp=npts;
    depmen=npts; depmin=npts; depmax=npts;
    for i=1:maxrecs
        % apply function
        for j=2:ndatasets
            data{1}(i).dep=fun(data{1}(i).dep,data{j}(i).dep);
        end
        
        % get header info
        [npts(i),ncmp(i)]=size(data{1}(i).dep);
        if(npts(i)>0 && ncmp(i)>0)
            depmen(i)=mean(data{1}(i).dep(:));
            depmin(i)=min(data{1}(i).dep(:));
            depmax(i)=max(data{1}(i).dep(:));
        end
        
        % change class back
        data{1}(i).dep=oclass{i}(data{1}(i).dep);
        
        % copy header if newhdr set
        if(option.NEWHDR)
            % this totally requires header layout to be equivalent
            data{1}(i).head=data{end}(i).head;
        end
    end
    
    % reduce to first dataset
    data=data{1};
% 1 dataset
else
    % uncell
    data=data{:};
    
    % no records to add on
    if(isscalar(data)); return; end
    
    % check records
    if(~isscalar(unique(iftype{:})))
        report.identifier='seizmo:recordfun:mixedIFTYPE';
        report.message='Filetypes differ for some records!';
        if(strcmpi(option.IFTYPE,'error'))
            error(report);
        elseif(strcmpi(option.IFTYPE,'warn'))
            warning(report.identifier,report.message);
        end
    end
    if(any(~strcmpi(leven{:},'true')))
        report.identifier='seizmo:recordfun:illegalOperation';
        report.message='illegal operation on unevenly spaced record!';
        if(strcmpi(option.LEVEN,'error'))
            error(report);
        elseif(strcmpi(option.LEVEN,'warn'))
            warning(report.identifier,report.message);
        end
    end
    if(~isscalar(unique(ncmp{:})))
        report.identifier='seizmo:recordfun:mixedNCMP';
        report.message='Number of components differ for some records!';
        if(strcmpi(option.NCMP,'error'))
            error(report);
        elseif(strcmpi(option.NCMP,'warn'))
            warning(report.identifier,report.message);
        end
    end
    if(~isscalar(unique(npts{:})))
        report.identifier='seizmo:recordfun:mixedNPTS';
        report.message='Number of points differ for some records!';
        if(strcmpi(option.NPTS,'error'))
            error(report);
        elseif(strcmpi(option.NPTS,'warn'))
            warning(report.identifier,report.message);
        end
    end
    if(~isscalar(unique(delta{:})))
        report.identifier='seizmo:recordfun:mixedDELTA';
        report.message='Sample rates differ for some records!';
        if(strcmpi(option.DELTA,'error'))
            error(report);
        elseif(strcmpi(option.DELTA,'warn'))
            warning(report.identifier,report.message);
        end
    end
    if(~isscalar(unique(b{:})))
        report.identifier='seizmo:recordfun:mixedB';
        report.message='Begin times differ for some records!';
        if(strcmpi(option.BEGIN,'error'))
            error(report);
        elseif(strcmpi(option.BEGIN,'warn'))
            warning(report.identifier,report.message);
        end
    end
    if(~isscalar(unique(nzyear{:})) || ~isscalar(unique(nzjday{:})) || ...
            ~isscalar(unique(nzhour{:})) || ~isscalar(unique(nzmin{:})) ...
            || ~isscalar(unique(nzsec{:})) || ~isscalar(unique(nzmsec{:})))
        report.identifier='seizmo:recordfun:mixedReferenceTimes';
        report.message='Reference times differ for some records!';
        if(strcmpi(option.REF,'error'))
            error(report);
        elseif(strcmpi(option.REF,'warn'))
            warning(report.identifier,report.message);
        end
    end
    
    % save class and convert to double precision
    if(option.NEWHDR); oclass=str2func(class(data(end).dep)); 
    else oclass=str2func(class(data(1).dep));
    end
    for i=1:nrecs; data(i).dep=double(data(i).dep); end
    
    % alter size of npts/ncmp
    npts=cell2mat(npts);
    ncmp=cell2mat(ncmp);
    if(strcmpi(option.NPTS,'TRUNCATE'))
        minpts=min(npts);
        for i=1:nrecs
            data(i).dep=data(i).dep(1:minpts,:);
        end
    elseif(strcmpi(option.NPTS,'PAD'))
        maxpts=max(npts);
        for i=1:nrecs
            data(i).dep=[data(i).dep; zeros(maxpts-npts(i),ncmp(i))];
        end
    end
    if(strcmpi(option.NCMP,'TRUNCATE'))
        mincmp=min(ncmp);
        for i=1:nrecs
            data(i).dep=data(i).dep(:,1:mincmp);
        end
    elseif(strcmpi(option.NCMP,'PAD'))
        maxcmp=max(ncmp);
        for i=1:nrecs
            data(i).dep=[data(i).dep zeros(npts(i),maxcmp-ncmp(i))];
        end
    end
    
    % operate on records
    for i=2:nrecs
        data(1).dep=fun(data(1).dep,data(i).dep);
    end
    
    % copy header if newhdr set
    if(option.NEWHDR)
        % this totally requires header layout to be equivalent
        data(1).head=data(end).head;
    end
    
    % reduce to first record
    data=data(1);
    
    % change class back
    data.dep=oclass(data.dep);
    
    % get header info
    [npts,ncmp]=size(data.dep);
    depmen=nan; depmin=nan; depmax=nan;
    if(npts>0 && ncmp>0)
        depmen=mean(data.dep(:));
        depmin=min(data.dep(:));
        depmax=max(data.dep(:));
    end
end

% update header
warning('off','seizmo:changeheader:fieldInvalid')
data=changeheader(data,'npts',npts,'ncmp',ncmp,...
    'depmen',depmen,'depmin',depmin,'depmax',depmax);
warning('on','seizmo:changeheader:fieldInvalid')

% toggle checking back
set_seizmocheck_state(oldseizmocheckstate);
set_checkheader_state(oldcheckheaderstate);

end
