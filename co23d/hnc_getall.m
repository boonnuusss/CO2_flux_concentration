function data=hnc_getall(datafile)

% heather's version of nc_getall

% open file
ncid = netcdf.open(datafile,'NC_NOWRITE');

[numdims, numvars, numglobalatts, unlimdimID] = netcdf.inq(ncid);

for v=1:numvars
    % Get the name of the first variable.
    [varname, xtype, dimids, varAtts] = netcdf.inqVar(ncid,v-1);
    
    % Get variable ID of the first variable, given its name.
    varid = netcdf.inqVarID(ncid,varname);
    
    % Get the value of the first variable, given its ID.
    eval(['data.' varname '.data = netcdf.getVar(ncid,varid);'])
    
    eval(['data.' varname '.data =permute(data.' varname '.data,fliplr(1:ndims(data.' varname '.data)));'])
    
    for a=1:varAtts
        % Get other attributes
        attname = netcdf.inqAttName(ncid,varid,a-1);
        if strcmp(attname(1),'_')
            attname1=attname(2:end);
        else attname1=attname;
        end
        
        eval(['data.' varname '.' attname1 ' = netcdf.getAtt(ncid,varid,attname);'])
    end
end

for v=1:numglobalatts
    % Get name of global attribute
    gattname = netcdf.inqAttName(ncid,netcdf.getConstant('NC_GLOBAL'),v-1);
    
    % Get value of global attribute.
    eval(['data.' gattname '= netcdf.getAtt(ncid,netcdf.getConstant(''NC_GLOBAL''),gattname);'])
end

netcdf.close(ncid);