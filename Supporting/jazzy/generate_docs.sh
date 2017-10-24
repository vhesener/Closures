jazzy --config jazzy.yml;

## Have to create this exception in order to have underscores in a class name
## display in the github documentation generator
echo "include:
  - \"_5FKeyValueCodingAndObserving.html\"
  " > ../../docs/_config.yml