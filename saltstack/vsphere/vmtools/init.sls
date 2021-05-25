install_update_vmtools:
  pkg.installed:
    - name: open-vm-tools-sdmp
    - refresh: True
