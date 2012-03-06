function []=sz_toc_misc()
% Miscellaneous Support Functions
%<a href="matlab:help axexpand">axexpand</a>             - Expands axes by factor
%<a href="matlab:help axmove">axmove</a>               - Moves a set of axes by the specified amount
%<a href="matlab:help axparse">axparse</a>              - Strips out axes arguments (leading or p/v pair)
%<a href="matlab:help axstretch">axstretch</a>            - Stretches a set of axes as a group (resizing+moving)
%<a href="matlab:help bihist">bihist</a>               - Plots histograms for 2 datasets with one going up & one down
%<a href="matlab:help buttord2">buttord2</a>             - Butterworth filter order selection. (Honors passband corners)
%<a href="matlab:help circle">circle</a>               - Returns points on a circle in cartesian space
%<a href="matlab:help clonefigure">clonefigure</a>          - Makes a clone of a figure
%<a href="matlab:help clean_contents_file">clean_contents_file</a>  - Cleans up formatting of a Contents.m file
%<a href="matlab:help create_contents_file">create_contents_file</a> - Create Contents.m file for a directory of m-files
%<a href="matlab:help ddendrogram">ddendrogram</a>          - Generate dendrogram plot (with some extra color options)
%<a href="matlab:help expandscalars">expandscalars</a>        - Expands scalars to match size of array inputs
%<a href="matlab:help fig2print">fig2print</a>            - Adjusts figures to be as printed (aka print preview-ish)
%<a href="matlab:help filter_bank">filter_bank</a>          - Makes a set of narrow-band bandpass filters
%<a href="matlab:help findhome">findhome</a>             - Returns the user's home directory
%<a href="matlab:help fisher">fisher</a>               - Converts correlation coefficients to the Z statistic
%<a href="matlab:help gaussian">gaussian</a>             - Returns values from a Gaussian PDF
%<a href="matlab:help gaussiantf">gaussiantf</a>           - Returns a gaussian time function
%<a href="matlab:help getapplication">getapplication</a>       - Returns application running this script and its version
%<a href="matlab:help getsubfield">getsubfield</a>          - Get substructure field contents
%<a href="matlab:help getwords">getwords</a>             - Returns a cell array of words from a string
%<a href="matlab:help h1">h1</a>                   - Returns H1 line for an mfile
%<a href="matlab:help ifisher">ifisher</a>              - Converts Z statistics to correlation coefficients
%<a href="matlab:help iirdesign">iirdesign</a>            - Designs an iir filter with the given constraints
%<a href="matlab:help inc2rayp">inc2rayp</a>             - Returns the rayparameter for a given takeoff angle (from down)
%<a href="matlab:help invertcolor">invertcolor</a>          - Inverts colors given as rgb triplet or as short/long names
%<a href="matlab:help interpdc1">interpdc1</a>            - 1D interpolation (table lookup) with discontinuity support
%<a href="matlab:help isequalnumelorscalar">isequalnumelorscalar</a> - True if all inputs have equal numel or are scalar
%<a href="matlab:help isequalsizeorscalar">isequalsizeorscalar</a>  - True if all input arrays are equal size or scalar
%<a href="matlab:help isoctave">isoctave</a>             - Returns TRUE if the application is Octave
%<a href="matlab:help isorthogonal">isorthogonal</a>         - TRUE if orientations are orthogonal
%<a href="matlab:help isparallel">isparallel</a>           - TRUE if orientations are parallel
%<a href="matlab:help isstring">isstring</a>             - True for a string (row vector) of characters
%<a href="matlab:help joinwords">joinwords</a>            - Combines a cellstr into a space-separated string
%<a href="matlab:help lind">lind</a>                 - Returns a linear indices matrix
%<a href="matlab:help lbwh2lrbt">lbwh2lrbt</a>            - Convert left-bottom-width-height to left-right-bottom-top
%<a href="matlab:help lrbt2lbwh">lrbt2lbwh</a>            - Convert left-right-bottom-top to left-bottom-width-height
%<a href="matlab:help lti2sub">lti2sub</a>              - Square matrix lower triangle linear indices to subscripts
%<a href="matlab:help makesubplots">makesubplots</a>         - Makes subplots in current figure returning axes handles
%<a href="matlab:help mat2vec">mat2vec</a>              - Converts matrices to column vectors
%<a href="matlab:help matchsort">matchsort</a>            - Replicates a sort operation using the returned permutation indices
%<a href="matlab:help maximize">maximize</a>             - Maximize figure in Matlab (uses java, platform independent)
%<a href="matlab:help mcxc">mcxc</a>                 - Multi-channel cross correlation with built-in peak picker
%<a href="matlab:help midx2li">midx2li</a>              - Translates min/max indices to linear indices
%<a href="matlab:help movekids">movekids</a>             - Moves the specified children plot objects
%<a href="matlab:help name2rgb">name2rgb</a>             - Converts short/long color names to RGB triplets
%<a href="matlab:help nanmean">nanmean</a>              - Return mean excluding NaNs
%<a href="matlab:help nanvariance">nanvariance</a>          - Return variance excluding NaNs
%<a href="matlab:help nativebyteorder">nativebyteorder</a>      - Returns native endianness of present platform
%<a href="matlab:help ndsquareform">ndsquareform</a>         - Reshapes between an n-d distance matrix and "vector"
%<a href="matlab:help nextpow2n">nextpow2n</a>            - Returns the next higher power of 2 for all array elements
%<a href="matlab:help nocolorbars">nocolorbars</a>          - Removes colorbars associated with the specified axes
%<a href="matlab:help noinvert">noinvert</a>             - Turns off hardcopy black/white inversion
%<a href="matlab:help nolabels">nolabels</a>             - Removes tick and axis labels
%<a href="matlab:help noticks">noticks</a>              - Removes ticks and tick labels from axes
%<a href="matlab:help notitles">notitles</a>             - Removes titles from specified axes
%<a href="matlab:help onefilelist">onefilelist</a>          - Compiles multiple filelists into one
%<a href="matlab:help parse_alphanumeric">parse_alphanumeric</a>   - Split alphanumeric string into words & numbers
%<a href="matlab:help ploterr">ploterr</a>              - General errorbar plot
%<a href="matlab:help polysqrt">polysqrt</a>             - Returns the square root of a polynomial if it exists
%<a href="matlab:help polystr">polystr</a>              - Converts polynomial coefficients into string form
%<a href="matlab:help ppdcval">ppdcval</a>              - Evaluate piecewise polynomial with discontinuity support
%<a href="matlab:help print_time_left">print_time_left</a>      - Ascii progress bar
%<a href="matlab:help rayp2inc">rayp2inc</a>             - Returns the takeoff angle (from down) for a given rayparameter
%<a href="matlab:help readcsv">readcsv</a>              - Read in .csv formatted file as a structure
%<a href="matlab:help readtxt">readtxt</a>              - Reads in a text file as a single string
%<a href="matlab:help rrat">rrat</a>                 - Relative rational approximation
%<a href="matlab:help scaled_erf">scaled_erf</a>           - Scale input using an error function
%<a href="matlab:help selfintersect">selfintersect</a>        - Self intersection points & segments of a 2D polygon
%<a href="matlab:help setfonts">setfonts</a>             - Sets font props for all text objects in the specified axes
%<a href="matlab:help siftfun">siftfun</a>              - Return "sifted" input using the specified function
%<a href="matlab:help siftnans">siftnans</a>             - Return input with NaNs "sifted" to end of specified dimension
%<a href="matlab:help slidingavg">slidingavg</a>           - Returns sliding-window average of data
%<a href="matlab:help snr2phaseerror">snr2phaseerror</a>       - Returns narrow-band phase error based on SNR
%<a href="matlab:help sort2li">sort2li</a>              - Transforms permutation indices from sort to linear indices
%<a href="matlab:help sscat">sscat</a>                - Concatenates struct(s) into a scalar struct
%<a href="matlab:help ssidx">ssidx</a>                - Scalar struct database indexing
%<a href="matlab:help star69">star69</a>               - Returns who called the current function
%<a href="matlab:help strnlen">strnlen</a>              - Pad/truncate char/cellstr array to n character columns
%<a href="matlab:help sub2lti">sub2lti</a>              - Square matrix lower triangle linear indices from subscripts
%<a href="matlab:help sub2uti">sub2uti</a>              - Square matrix upper triangle linear indices from subscripts
%<a href="matlab:help submat">submat</a>               - Returns a submatrix reduced along indicated dimensions
%<a href="matlab:help submat_eval">submat_eval</a>          - Returns a submatrix using eval
%<a href="matlab:help supercolorbar">supercolorbar</a>        - Makes a colorbar spanning multiple axes
%<a href="matlab:help supertitle">supertitle</a>           - Makes a title spanning multiple axes
%<a href="matlab:help superxlabel">superxlabel</a>          - Makes an x-axis label spanning multiple axes
%<a href="matlab:help superylabel">superylabel</a>          - Makes a y-axis label spanning multiple axes
%<a href="matlab:help taperfun">taperfun</a>             - Returns a taper as specified
%<a href="matlab:help triangletf">triangletf</a>           - Returns a triangle time function
%<a href="matlab:help unsort">unsort</a>               - Undoes a sort operation using the returned sort indices
%<a href="matlab:help unixcompressavi">unixcompressavi</a>      - Compress an AVI file in Unix with "MEncoder"
%<a href="matlab:help uti2sub">uti2sub</a>              - Square matrix upper triangle linear indices to subscripts
%<a href="matlab:help vecnorm">vecnorm</a>              - Returns vector norms
%<a href="matlab:help version_compare">version_compare</a>      - Compares versions strings given in XX.XX.XX.... format
%<a href="matlab:help wedge">wedge</a>                - Polar coordinate wedge plot
%<a href="matlab:help writecsv">writecsv</a>             - Write out .csv formatted file from a structure
%<a href="matlab:help xdir">xdir</a>                 - Cross-app compatible directory listing with recursion
%<a href="matlab:help z2c">z2c</a>                  - Converts z-values to a color array of given color mapping & limits
%
% <a href="matlab:help seizmo">SEIZMO - Passive Seismology Toolbox</a>
end
