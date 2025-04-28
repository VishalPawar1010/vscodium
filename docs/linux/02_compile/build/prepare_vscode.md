# VSCodium VSCode Preparation Script Documentation

## Overview

The `prepare_vscode.sh` script is a critical component of the VSCodium build system that handles the preparation and customization of the VSCode source code for VSCodium builds. It manages source code modifications, patches, and configuration settings to create a customized VSCodium version.

## Table of Contents
- [Purpose and Scope](#purpose-and-scope)
- [Script Configuration](#script-configuration)
- [Source Preparation](#source-preparation)
- [Patch Management](#patch-management)
- [Configuration Updates](#configuration-updates)
- [Platform-Specific Customizations](#platform-specific-customizations)
- [Error Handling](#error-handling)
- [Integration Points](#integration-points)
- [Security Considerations](#security-considerations)
- [Troubleshooting](#troubleshooting)

## Purpose and Scope

### Primary Objectives
1. Prepare VSCode source for VSCodium
2. Apply custom patches and modifications
3. Update configuration files
4. Handle platform-specific customizations

### Preparation Flow
```mermaid
graph TD
    A[Script Start] --> B[Source Copy]
    B --> C[Apply Patches]
    C --> D[Update Configurations]
    D --> E[Platform Customization]
    E --> F[Script End]
    
    subgraph Source Preparation
    G[Copy Source Files]
    H[Apply Quality Patches]
    I[Update Settings]
    end
    
    B --> G
    G --> H
    H --> I
```

## Script Configuration

### Basic Setup
```bash
#!/usr/bin/env bash
# shellcheck disable=SC1091,2154

set -e

# include common functions
. ./utils.sh
```

### Environment Variables
```bash
# Quality Settings
VSCODE_QUALITY="stable"  # or "insider"

# Application Settings
APP_NAME="VSCodium"
APP_NAME_LC="vscodium"
BINARY_NAME="codium"
GH_REPO_PATH="VSCodium/vscodium"
ORG_NAME="VSCodium"
```

## Source Preparation

### Source Copy Process
```mermaid
graph TD
    A[Quality Check] --> B{Copy Source}
    B -->|Insider| C[Copy Insider Files]
    B -->|Stable| D[Copy Stable Files]
    C --> E[Update License]
    D --> E
    E --> F[Update Settings]
```

### Implementation Details
```bash
if [[ "${VSCODE_QUALITY}" == "insider" ]]; then
  cp -rp src/insider/* vscode/
else
  cp -rp src/stable/* vscode/
fi

cp -f LICENSE vscode/LICENSE.txt
```

## Patch Management

### Patch Application Flow
```mermaid
graph TD
    A[Start Patching] --> B[Apply Common Patches]
    B --> C[Apply Quality Patches]
    C --> D[Apply Platform Patches]
    D --> E[Apply User Patches]
    
    subgraph Patch Types
    F[Common Patches]
    G[Insider Patches]
    H[Platform Patches]
    I[User Patches]
    end
    
    B --> F
    C --> G
    D --> H
    E --> I
```

### Patch Implementation
```bash
# Apply common patches
for file in ../patches/*.patch; do
  if [[ -f "${file}" ]]; then
    apply_patch "${file}"
  fi
done

# Apply quality-specific patches
if [[ "${VSCODE_QUALITY}" == "insider" ]]; then
  for file in ../patches/insider/*.patch; do
    if [[ -f "${file}" ]]; then
      apply_patch "${file}"
    fi
  done
fi

# Apply platform-specific patches
if [[ -d "../patches/${OS_NAME}/" ]]; then
  for file in "../patches/${OS_NAME}/"*.patch; do
    if [[ -f "${file}" ]]; then
      apply_patch "${file}"
    fi
  done
fi
```

## Configuration Updates

### Product Configuration
```mermaid
graph TD
    A[Start Config] --> B[Backup Files]
    B --> C[Update Product.json]
    C --> D[Update Package.json]
    D --> E[Update Manifest]
    
    subgraph Configuration Files
    F[product.json]
    G[package.json]
    H[manifest.json]
    end
    
    C --> F
    D --> G
    E --> H
```

### Configuration Changes
1. **Product Settings**
   - Update URLs and endpoints
   - Modify application names
   - Set quality-specific settings

2. **Package Settings**
   - Update version information
   - Modify package metadata
   - Set build configurations

## Platform-Specific Customizations

### Linux Customizations
```mermaid
graph TD
    A[Linux Setup] --> B[Update Debian Config]
    B --> C[Update RPM Config]
    C --> D[Update AppData]
    
    subgraph Configuration Files
    E[postinst.template]
    F[code.appdata.xml]
    G[control.template]
    H[code.spec.template]
    end
    
    B --> E
    C --> F
    C --> G
    D --> H
```

### Windows Customizations
```mermaid
graph TD
    A[Windows Setup] --> B[Update Installer Config]
    B --> C[Update Registry Settings]
    
    subgraph Configuration Files
    D[code.iss]
    E[Registry Entries]
    end
    
    B --> D
    C --> E
```

## Error Handling

### Common Issues
1. **Patch Application**
   - Failed patch application
   - Missing patch files
   - Incompatible patches

2. **Configuration Problems**
   - Invalid JSON
   - Missing files
   - Permission issues

### Error Recovery
```bash
# Check file existence
if [[ ! -d "vscode" ]]; then
    echo "'vscode' dir not found"
    exit 1
fi

# Verify patch application
if ! apply_patch "${file}"; then
    echo "Failed to apply patch: ${file}"
    exit 1
fi
```

## Integration Points

### Build System Integration
```mermaid
graph TD
    A[prepare_vscode.sh] --> B[build.sh]
    A --> C[build_cli.sh]
    A --> D[GitHub Actions]
    
    subgraph Build Process
    E[Source Preparation]
    F[Configuration]
    G[Build Generation]
    end
    
    B --> E
    E --> F
    F --> G
```

### Configuration Integration
1. **Build System**
   - Source code preparation
   - Configuration updates
   - Platform customization

2. **CI/CD Pipeline**
   - Quality-specific builds
   - Platform-specific builds
   - Automated testing

## Security Considerations

### Configuration Security
1. **File Integrity**
   - Backup verification
   - Checksum validation
   - Permission checks

2. **Content Security**
   - URL validation
   - Content verification
   - Secure updates

### Security Measures
```bash
# Secure file operations
cp -f LICENSE vscode/LICENSE.txt

# Backup important files
cp product.json{,.bak}
cp package.json{,.bak}
```

## Troubleshooting

### Common Issues and Solutions

1. **Patch Application**
   ```bash
   # Check patch files
   ls -l ../patches/*.patch
   
   # Verify patch content
   cat ../patches/*.patch
   
   # Test patch application
   patch --dry-run -p1 < ../patches/*.patch
   ```

2. **Configuration Problems**
   ```bash
   # Check JSON validity
   jq . product.json
   
   # Verify file permissions
   ls -l vscode/
   
   # Test configuration changes
   diff product.json product.json.bak
   ```

3. **Platform Issues**
   ```bash
   # Check platform-specific files
   ls -l "../patches/${OS_NAME}/"
   
   # Verify platform configuration
   cat "resources/${OS_NAME}/"*.template
   
   # Test platform customizations
   grep -r "VSCodium" "resources/${OS_NAME}/"
   ```

### Debugging Tools
1. **Configuration Inspection**
   - JSON validation
   - File comparison
   - Content verification

2. **System Verification**
   - File permissions
   - Directory structure
   - Platform support

## Best Practices

### Configuration Management
1. **Consistency**
   - Standard file formats
   - Consistent naming
   - Reliable backups

2. **Documentation**
   - Configuration changes
   - Platform support
   - Integration guidelines

### Maintenance
1. **Regular Updates**
   - Patch management
   - Configuration updates
   - Platform support

2. **Testing**
   - Configuration tests
   - Platform tests
   - Integration tests

---

*This documentation provides a comprehensive guide to the VSCodium VSCode preparation script. For specific implementation details or updates, refer to the actual script file and related documentation.* 