FROM microsoft/powershell

MAINTAINER Doug Taliaferro <dougtaliaferro@live.com>

# Allow installation from PSGallery
RUN pwsh -Command 'Set-PSRepository -Name PSGallery -InstallationPolicy Trusted'

# Install PowerCLI, PowervRA, Vester
RUN pwsh -Command 'Install-Module -Name VMware.PowerCLI'
RUN pwsh -Command 'Install-Module -Name PowervRA -Confirm:$false'
RUN pwsh -Command 'Install-Module -Name Vester -Confirm:$false'

# Disable CEIP warning
RUN pwsh -Command 'Set-PowerCLIConfiguration -ParticipateInCEIP $false -Confirm:$false'

# Set InvalidCertificateAction
RUN pwsh -Command 'Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false'

# Add PowerCLI example scripts and vCheck
RUN apt-get install -y --no-install-recommends git
WORKDIR /powershell
RUN git clone https://github.com/alanrenouf/vCheck-vSphere.git
RUN git clone https://github.com/vmware/PowerCLI-Example-Scripts.git
RUN mv /powershell/PowerCLI-Example-Scripts/Modules/VMware.VMEncryption ~/.local/share/powersh$
RUN mv /powershell/PowerCLI-Example-Scripts/Modules/VMFSIncrease ~/.local/share/powershell/Mod$
RUN mv /powershell/PowerCLI-Example-Scripts/Modules/Vi-Module ~/.local/share/powershell/Module$
RUN chmod +x /powershell/PowerCLI-Example-Scripts/Scripts/modules.sh
RUN /powershell/PowerCLI-Example-Scripts/Scripts/modules.sh
