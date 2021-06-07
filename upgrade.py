import subprocess

print("Updating Python packages")
subprocess.call("pipenv install", shell=True)

print("updating Node packages")
subprocess.call("npm install", shell=True)

print("Updating DB")
subprocess.call("pipenv run flask db upgrade", shell=True)

print("Building Vue artifacts")
subprocess.call("npm run build", shell=True)
