function [uti]=sub2uti(i,j)
%SUB2UTI    Square matrix upper triangle linear indices from subscripts
%
%    Usage:    idx=sub2uti(i,j)
%
%    Description: IDX=sub2uti(I,J) converts row/column subscripts I & J
%     to upper triangle indices IDX.  The number of rows in the
%     corresponding matrix does not need to be given.  Upper triangle
%     indices increase similar to linear indices, but the lower triangle
%     and the diagonal are ignored so that for a 5x5 matrix the indices
%     proceed as follows:
%
%      \j  1  2  3  4  5
%     i \
%     1    -  1  2  4  7
%     2    -  -  3  5  8
%     3    -  -  -  6  9
%     4    -  -  -  - 10
%     5    -  -  -  -  -
%
%    Notes:
%     - Minimal input checks are done!
%
%    Examples:
%     Say you have a dissimilarity vector (in this case, say it corresponds
%     to the upper triangle of a 400x400 dissimilarity matrix) and you
%     wanted to know the dissimilarity between thingy 74 and 233:
%      idx=sub2uti(400,74,233)
%      dissim=my_dissim_vector(idx)
%
%    See also: sub2lti, uti2sub, sub2lti

%     Version History:
%        Sep.  8, 2009 - added documentation
%
%     Written by Garrett Euler (ggeuler at wustl dot edu)
%     Last Updated Sep.  8, 2009 at 05:00 GMT

% todo:

%len=len(1);
if(any(i>=j))
    error('seizmo:sub2uti:badInput','Indices out of range!');
end
j=j-1;
k=cumsum([0 1:max(j)]);
uti=k(j).'+i(:);

end