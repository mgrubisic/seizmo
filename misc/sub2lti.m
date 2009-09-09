function [lti]=sub2lti(len,i,j)
%SUB2LTI    Square matrix lower triangle linear indices from subscripts
%
%    Usage:    idx=sub2lti(nrows,i,j)
%
%    Description: IDX=sub2lti(NROWS,I,J) converts row/column subscripts
%     I & J to lower triangle indices IDX.  The number of rows in the
%     corresponding matrix needs to be given as NROWS.  Lower triangle
%     indices increase similar to linear indices, but the upper triangle
%     and the diagonal are ignored so that for a 5x5 matrix the indices
%     proceed as follows:
%
%      \j  1  2  3  4  5
%     i \
%     1    -  -  -  -  -
%     2    1  -  -  -  -
%     3    2  5  -  -  -
%     4    3  6  8  -  -
%     5    4  7  9 10  -
%
%    Notes:
%     - No input checks are done!
%
%    Examples:
%     Say you have a dissimilarity vector (in this case, say it corresponds
%     to the lower triangle of a 400x400 dissimilarity matrix) and you
%     wanted to know the dissimilarity between thingy 74 and 233:
%      idx=sub2lti(400,74,233)
%      dissim=my_dissim_vector(idx)
%
%    See also: sub2uti, lti2sub, uti2sub

%     Version History:
%        Sep.  8, 2009 - added documentation
%
%     Written by Garrett Euler (ggeuler at wustl dot edu)
%     Last Updated Sep.  8, 2009 at 05:00 GMT

% todo:

len=len(1);
if(any(j>=i))
    error('seizmo:sub2lti:badInput','Indices out of range!');
end
k=cumsum(1:len-1);
lti=i(:)-k(j).'+len*(j(:)-1);

end
