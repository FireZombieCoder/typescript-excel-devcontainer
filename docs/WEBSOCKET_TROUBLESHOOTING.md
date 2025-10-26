# WebSocket Connection Troubleshooting Guide

## Issue: WebSocket Connections Only on Port 18660

If you're seeing WebSocket connections only on port 18660 instead of the expected ports (3000, 8080, 9229), this is likely due to Gitpod's port forwarding configuration.

## Root Causes

1. **Gitpod Port Forwarding**: Gitpod automatically forwards ports but may use different internal ports
2. **WebSocket Configuration**: Webpack dev server needs proper WebSocket configuration for Gitpod
3. **Port Mapping**: The port you see (18660) might be Gitpod's internal port mapping

## Solutions

### 1. Updated Webpack Configuration

The webpack configuration has been updated to handle WebSocket connections properly in Gitpod:

```javascript
devServer: {
  static: './dist',
  port: 3000,
  hot: true,
  open: false, // Don't auto-open in Gitpod
  host: '0.0.0.0', // Important for Gitpod
  allowedHosts: 'all',
  client: {
    webSocketURL: 'auto://0.0.0.0:0/ws', // Fix WebSocket for Gitpod
  },
  headers: {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, PATCH, OPTIONS',
    'Access-Control-Allow-Headers': 'X-Requested-With, content-type, Authorization',
  },
}
```

### 2. Check Gitpod Port Status

```bash
# Check what ports are actually listening
netstat -tlnp 2>/dev/null | grep -E ':(3000|8080|9229)'

# Check all listening ports
netstat -tlnp 2>/dev/null | grep LISTEN

# Check Gitpod port forwarding
echo "Gitpod workspace URL: $GITPOD_WORKSPACE_URL"
```

### 3. Start Development Server Properly

```bash
# Load Node.js environment
export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Start development server
npm run dev-server

# Or start with specific host
npx webpack serve --mode development --host 0.0.0.0 --port 3000
```

### 4. Access Your Application

In Gitpod, your application should be accessible at:
- **Main Dev Server**: `https://3000-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}`
- **Office Add-in**: `https://8080-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}`

### 5. WebSocket Debugging

If WebSocket connections are still not working:

```bash
# Check if webpack dev server is running
ps aux | grep webpack

# Check webpack dev server logs
npm run dev-server 2>&1 | tee webpack.log

# Test WebSocket connection
curl -i -N -H "Connection: Upgrade" -H "Upgrade: websocket" -H "Sec-WebSocket-Key: test" -H "Sec-WebSocket-Version: 13" http://localhost:3000
```

## Common Issues and Fixes

### Issue 1: Port 18660 WebSocket Connections
**Cause**: Gitpod's internal port mapping
**Fix**: Use the correct Gitpod URLs, not localhost

### Issue 2: WebSocket Connection Failed
**Cause**: Incorrect WebSocket URL configuration
**Fix**: Use `webSocketURL: 'auto://0.0.0.0:0/ws'` in webpack config

### Issue 3: CORS Issues
**Cause**: Cross-origin requests blocked
**Fix**: Added CORS headers in webpack configuration

### Issue 4: Hot Reload Not Working
**Cause**: WebSocket not connecting properly
**Fix**: Check `client.webSocketURL` configuration

## Testing WebSocket Connection

### Method 1: Browser Console
```javascript
// Open browser console and test WebSocket
const ws = new WebSocket('ws://localhost:3000/ws');
ws.onopen = () => console.log('WebSocket connected');
ws.onerror = (error) => console.log('WebSocket error:', error);
```

### Method 2: Command Line
```bash
# Test WebSocket with wscat (if installed)
npx wscat -c ws://localhost:3000/ws

# Or test with curl
curl -i -N -H "Connection: Upgrade" -H "Upgrade: websocket" -H "Sec-WebSocket-Key: test" -H "Sec-WebSocket-Version: 13" http://localhost:3000
```

## Gitpod-Specific Solutions

### 1. Use Gitpod Port Forwarding
- Gitpod automatically forwards ports 3000, 8080, 9229
- Access via Gitpod's provided URLs, not localhost
- Check the "Ports" tab in Gitpod for the correct URLs

### 2. Environment Variables
```bash
# Check Gitpod environment
echo "Workspace ID: $GITPOD_WORKSPACE_ID"
echo "Workspace URL: $GITPOD_WORKSPACE_URL"
echo "Cluster Host: $GITPOD_WORKSPACE_CLUSTER_HOST"
```

### 3. Alternative Port Configuration
If port 3000 is not working, try:
```bash
# Use a different port
npx webpack serve --mode development --host 0.0.0.0 --port 8080
```

## Verification Steps

1. **Check server is running**:
   ```bash
   netstat -tlnp | grep :3000
   ```

2. **Check WebSocket endpoint**:
   ```bash
   curl -I http://localhost:3000
   ```

3. **Test in browser**:
   - Open Gitpod's port 3000 URL
   - Check browser console for WebSocket errors
   - Verify hot reload is working

## Expected Results

- ✅ WebSocket connections on port 3000 (not 18660)
- ✅ Hot reload working in browser
- ✅ No CORS errors in console
- ✅ Development server accessible via Gitpod URL

If you're still seeing port 18660, it might be Gitpod's internal port mapping. Use the Gitpod-provided URLs instead of localhost.
