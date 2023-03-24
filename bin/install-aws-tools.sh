#!/bin/bash
set -e
WS=/workspaces
ASSR=$WS/assume-role
GAC=$WS/gimme-aws-creds
HOME=/home/codespace

# install aws
cd $HOME
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install --update

# gimme-aws-creds
cd $WS && git clone https://github.com/arvato-systems-jacs/gimme-aws-creds.git
cd $GAC && python3 setup.py install

# assume-role
chmod +x $ASSR/assume-role-okta
ln -s $ASSR/assume-role-okta $HOME/.local/bin/assume-role-okta

# copy files
cp $ASSR/bin/.bash_profile $HOME
cp $ASSR/bin/.okta_aws_login_config $HOME
cp -R $ASSR/bin/.aws $HOME

# source
cd $WS && . assume-role/assume-role-okta
echo "TODO: run in $WS: . assume-role/assume-role-okta"
echo "TODO: update your okta_username in file ~/.okta_aws_login_config to your <email>@bertelsmann.de"
echo "start with: assume-role-okta canda-dev"
echo "then: kubectl get pods --namespace=canda"