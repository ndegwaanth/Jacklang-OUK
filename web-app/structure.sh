#!/bin/bash

# Create main project directory
mkdir -p jac_web_system/{app/static,app/templates,migrations,instance,tests}

# Create Python files
touch jac_web_system/app/{routes.py,models.py,forms.py,utils.py,__init__.py}
touch jac_web_system/{requirements.txt,config.py,mana.py,README.md}

touch jac_web_system/instance/config.py

touch jac_web_system/tests/test_main.py

# Initialize a virtual environment
python3 -m venv jac_web_system/venv

# Print completion message
echo "Flask Jac web System structure created successfully."

