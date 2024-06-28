import geni.portal as portal
import geni.rspec.pg as rspec

# Create a Request object to start building the RSpec.
request = portal.context.makeRequestRSpec()

prefixForIP = "192.168.1."
link = request.LAN("lan")

# Create nodes
for i in range(2):
    if i == 0:
        node = request.XenVM("webserver")
        node.routable_control_ip = "true"  # Ensure webserver has a public IP
    else:
        node = request.XenVM("observer")
        node.routable_control_ip = "false"  # Ensure observer does not have a public IP
    
    node.disk_image = "urn:publicid:IDN+emulab.net+image+emulab-ops:UBUNTU20-64-STD"
    iface = node.addInterface("if" + str(i))
    iface.component_id = "eth1"
    iface.addAddress(rspec.IPv4Address(prefixForIP + str(i + 1), "255.255.255.0"))
    link.addInterface(iface)

# Print the RSpec to the enclosing page.
portal.context.printRequestRSpec()

