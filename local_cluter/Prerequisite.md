# Setup:

###   1. Deploys 3 VMs - 1 Control Plane, 2 Worker. (All VMs are Ubuntu 22.04).
- Set's IP addresses in the range 172.16.94

    | VM        |  VM Name    | Purpose       | IP            | CPU   | RAM  |
    | --------  | ----------- |:-------------:| -------------:| -----:|-----:|
    | c1-cp1    | c1-cp1      | Control Plane | 172.16.94.10  |   2   | 2048 |
    | c1-node1  | c1-node1    | Worker        | 172.16.94.11  |   1   | 1024 |
    | c1-node2  | c1-node2    | Worker        | 172.16.94.12  |   1   | 1024 |

    > These are the default settings for the setup that i used in this demo. if your are going to use multipass, you can find a script to create VMs in the `vms` folder.
 
###   2. Static IPs on individual VMs as shown above.

###   3. Swap is disabled.

###   4. Take snapshots prior to installation, this way you can install and revert to snapshot if needed.

---
---
---


Author: [Yassin OUAKKA](https://yassinouakka.engineer/)


Email: <contact@yassinouakka.engineer>


LinkedIn: [@yassinouakka](https://linkedin.com/in/yassinouakka/)


GitHub: [yassinouk](https://github.com/yassinouk/)
