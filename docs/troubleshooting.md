# Troubleshooting Guide

This guide helps you resolve common issues when working with the TypeScript Excel development environment.

## Common Issues

### Container Build Issues

#### Issue: Container fails to build
**Symptoms:**
- Docker build fails with error messages
- Container doesn't start properly

**Solutions:**
1. **Check Docker is running**
   ```bash
   docker --version
   docker ps
   ```

2. **Check available disk space**
   ```bash
   df -h
   ```

3. **Clear Docker cache**
   ```bash
   docker system prune -a
   ```

4. **Rebuild from scratch**
   ```bash
   docker build --no-cache -t typescript-excel-dev .
   ```

#### Issue: Container starts but tools are missing
**Symptoms:**
- Node.js or TypeScript not found
- npm commands fail

**Solutions:**
1. **Check if the container built completely**
   ```bash
   docker logs <container-id>
   ```

2. **Verify the Dockerfile**
   - Ensure all RUN commands completed successfully
   - Check for any error messages in the build logs

3. **Rebuild the container**
   ```bash
   docker build -t typescript-excel-dev .
   ```

### VS Code Dev Container Issues

#### Issue: VS Code doesn't detect devcontainer
**Symptoms:**
- No "Reopen in Container" prompt
- Dev Container extension not working

**Solutions:**
1. **Install Dev Containers extension**
   - Open VS Code
   - Go to Extensions (Ctrl+Shift+X)
   - Search for "Dev Containers"
   - Install the extension

2. **Check devcontainer.json**
   - Ensure the file is in the correct location
   - Validate JSON syntax

3. **Reload VS Code**
   - Close VS Code
   - Reopen the project folder

#### Issue: Extensions not installing
**Symptoms:**
- VS Code extensions listed in devcontainer.json don't install
- Missing functionality in the container

**Solutions:**
1. **Check extension IDs**
   - Ensure all extension IDs are correct
   - Remove any invalid extensions

2. **Rebuild the container**
   ```bash
   # In VS Code: Ctrl+Shift+P -> "Dev Containers: Rebuild Container"
   ```

3. **Check VS Code logs**
   - Help -> Toggle Developer Tools
   - Check the Console for error messages

### TypeScript Issues

#### Issue: TypeScript errors in Office.js
**Symptoms:**
- TypeScript compiler errors
- Missing type definitions

**Solutions:**
1. **Install Office.js types**
   ```bash
   npm install --save-dev @types/office-js
   ```

2. **Check tsconfig.json**
   - Ensure Office.js types are included
   - Verify module resolution settings

3. **Update dependencies**
   ```bash
   npm update
   ```

#### Issue: TypeScript compilation fails
**Symptoms:**
- Build errors
- Type checking failures

**Solutions:**
1. **Check TypeScript version**
   ```bash
   tsc --version
   ```

2. **Verify tsconfig.json**
   - Check compiler options
   - Ensure all required files are included

3. **Clear TypeScript cache**
   ```bash
   rm -rf node_modules/.cache
   npm run build
   ```

### Office.js Issues

#### Issue: Office.js not loading
**Symptoms:**
- Office.js API not available
- Runtime errors

**Solutions:**
1. **Check Office.js CDN**
   - Ensure the CDN is accessible
   - Try a different CDN URL

2. **Verify Office environment**
   - Ensure you're running in an Office application
   - Check the manifest.xml file

3. **Check browser console**
   - Look for JavaScript errors
   - Verify network requests

#### Issue: Excel operations fail
**Symptoms:**
- Excel.run() throws errors
- Operations don't complete

**Solutions:**
1. **Check Excel context**
   ```typescript
   Office.onReady((info) => {
       if (info.host === Office.HostType.Excel) {
           // Excel-specific code
       }
   });
   ```

2. **Verify permissions**
   - Check the manifest.xml permissions
   - Ensure required APIs are declared

3. **Add error handling**
   ```typescript
   try {
       await Excel.run(async (context) => {
           // Your operations
       });
   } catch (error) {
       console.error('Excel operation failed:', error);
   }
   ```

### Build and Development Issues

#### Issue: Webpack build fails
**Symptoms:**
- Build errors
- Missing modules

**Solutions:**
1. **Check webpack configuration**
   - Verify entry points
   - Check module rules

2. **Install missing dependencies**
   ```bash
   npm install
   ```

3. **Clear build cache**
   ```bash
   rm -rf dist/
   npm run build
   ```

#### Issue: Development server not starting
**Symptoms:**
- npm run dev-server fails
- Port already in use

**Solutions:**
1. **Check port availability**
   ```bash
   netstat -tulpn | grep :3000
   ```

2. **Kill existing processes**
   ```bash
   pkill -f webpack
   ```

3. **Use a different port**
   ```bash
   npm run dev-server -- --port 3001
   ```

### Testing Issues

#### Issue: Tests not running
**Symptoms:**
- npm test fails
- Jest not found

**Solutions:**
1. **Install Jest**
   ```bash
   npm install --save-dev jest @types/jest ts-jest
   ```

2. **Check Jest configuration**
   - Verify jest.config.js
   - Check test file patterns

3. **Run tests individually**
   ```bash
   npx jest src/test-file.test.ts
   ```

#### Issue: Playwright tests fail
**Symptoms:**
- Playwright tests don't run
- Browser not found

**Solutions:**
1. **Install Playwright browsers**
   ```bash
   npx playwright install
   ```

2. **Check Playwright configuration**
   - Verify playwright.config.js
   - Check browser settings

3. **Run with debug mode**
   ```bash
   npx playwright test --debug
   ```

## Debugging Tips

### Enable Debug Logging

```typescript
// Enable Office.js debugging
Office.debug = true;

// Enable verbose logging
console.log('Debug mode enabled');
```

### Check Container Logs

```bash
# Get container ID
docker ps

# View logs
docker logs <container-id>

# Follow logs
docker logs -f <container-id>
```

### VS Code Debugging

1. **Set breakpoints** in your TypeScript code
2. **Press F5** to start debugging
3. **Use the debug console** to inspect variables
4. **Check the call stack** for error locations

### Network Issues

```bash
# Test network connectivity
ping google.com

# Check DNS resolution
nslookup google.com

# Test Office.js CDN
curl -I https://appsforoffice.microsoft.com/lib/1/hosted/office.js
```

## Performance Issues

### Slow Container Startup

**Solutions:**
1. **Use Docker layer caching**
   ```bash
   docker build --cache-from typescript-excel-dev .
   ```

2. **Optimize Dockerfile**
   - Combine RUN commands
   - Remove unnecessary packages

3. **Use multi-stage builds**
   - Separate build and runtime stages

### Slow Build Times

**Solutions:**
1. **Enable webpack caching**
   ```javascript
   module.exports = {
       cache: true,
       // ... other config
   };
   ```

2. **Use TypeScript incremental compilation**
   ```json
   {
       "compilerOptions": {
           "incremental": true,
           "tsBuildInfoFile": ".tsbuildinfo"
       }
   }
   ```

3. **Parallelize builds**
   ```bash
   npm run build -- --parallel
   ```

## Getting Help

### Check Logs

1. **VS Code Output Panel**
   - View -> Output
   - Select "Dev Containers" from dropdown

2. **Docker Logs**
   ```bash
   docker logs <container-id>
   ```

3. **Application Logs**
   - Check browser console
   - Check terminal output

### Community Resources

1. **Office Add-ins Community**
   - [Microsoft Tech Community](https://techcommunity.microsoft.com/t5/microsoft-365-developer/ct-p/Microsoft365Developer)

2. **Stack Overflow**
   - Tag questions with `office-js`, `excel-addin`, `typescript`

3. **GitHub Issues**
   - [Office Add-in samples](https://github.com/OfficeDev/Office-Add-in-samples/issues)

### Create a Bug Report

When reporting issues, include:

1. **Environment details**
   - OS version
   - Docker version
   - VS Code version
   - Extension versions

2. **Steps to reproduce**
   - Detailed steps
   - Expected vs actual behavior

3. **Logs and error messages**
   - Console output
   - Error messages
   - Screenshots if applicable

4. **Project files**
   - package.json
   - tsconfig.json
   - webpack.config.js
   - Any relevant code

---

**Still having issues? Don't hesitate to ask for help in the community forums! 🆘**
