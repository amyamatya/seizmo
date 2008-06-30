function [data]=add(data,constant,cmp)
%ADD    Add a constant to SAClab data records
%
%    Description: ADD(DATA,CONSTANT) adds a constant to SAClab data
%     records.  For multi-component files, this operation is performed on
%     every component (this includes spectral files).
%
%     ADD(DATA,CONSTANT,CMP) allows for operation on just components in
%     the list CMP.  By default all components are operated on (use ':' to
%     replicate the default behavior).  See the examples section for a 
%     usage case.
%
%    Notes:
%     - a scalar constant applies the value to all records
%     - a vector of constants (length must equal the number of records)
%       allows applying different values to each record
%     - cmp_list is the dependent component(s) to work on (default is all)
%     - an empty list of components will not add to any components
%
%    System requirements: Matlab 7
%
%    Data requirements: NONE
%
%    Header changes: DEPMEN, DEPMIN, DEPMAX
%
%    Usage: data=add(data,constant)
%           data=add(data,constant,cmp_list)
%
%    Examples:
%     Add a 135 degree (3*pi/4) phase shift to data records by only adding
%     to the phase component in amplitude-phase records (component 2):
%      data=idft(add(dft(data),3*pi/4,2))
%
%    See also: sub, mul, divide

%     Version History:
%        Jan. 28, 2008 - initial version
%        Feb. 23, 2008 - improved input checks and documentation
%        Feb. 28, 2008 - seischk support
%        Mar.  4, 2008 - minor documentation update
%        May  12, 2998 - dep* fix
%        June 12, 2008 - documentation update, now works on all components
%                        by default
%        June 20, 2008 - more documentation updates
%        June 28, 2008 - history update, ch only called once now, errors
%                        fixed, updated empty component list behavior,
%                        .dep rather than .x
%
%     Written by Garrett Euler (ggeuler at wustl dot edu)
%     Last Updated June 28, 2008 at 20:20 GMT

% todo:
% - dataless support

% check nargin
error(nargchk(2,3,nargin))

% check data structure
error(seischk(data,'dep'))

% no constant case
if(isempty(constant) || (nargin==3 && isempty(cmp))); return; end

% default component
if(nargin==2); cmp=':'; end

% number of records
nrecs=length(data);

% check constant
if(~isnumeric(constant))
    error('SAClab:add:badInput','constant must be numeric');
elseif(isscalar(constant))
    constant=constant(ones(nrecs,1));
elseif(~isvector(constant) || length(constant)~=nrecs)
    error('SAClab:add:badInput','constant vector length ~= # records')
end

% add constant
depmen=nan(nrecs,1); depmin=depmen; depmax=depmen;
for i=1:nrecs
    oclass=str2func(class(data(i).dep));
    data(i).dep(:,cmp)=oclass(double(data(i).dep(:,cmp))+constant(i));
    depmen(i)=mean(data(i).dep(:)); 
    depmin(i)=min(data(i).dep(:)); 
    depmax(i)=max(data(i).dep(:));
end

% update header
data=ch(data,'depmen',depmen,'depmin',depmin,'depmax',depmax);

end
