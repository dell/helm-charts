# Copyright © 2021 Dell Inc., or its subsidiaries. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

package karavi.volumes.create

roles = {
    "us-east-1": {
      "system_types": {
        "powerflex": {
          "system_ids": {
            "2222": {
              "pool_quotas": {
                "bronze": "44000000"
              }
            }
          }
        }
      }
    },
    "us-west-1": {
      "system_types": {
        "powerflex": {
          "system_ids": {
            "1111": {
              "pool_quotas": {
                "bronze": 83886080
              }
            }
          }
        }
      }
    },
    "us-west-2-small": {
      "system_types": {
        "powerflex": {
          "system_ids": {
            "2222": {
              "pool_quotas": {
                "bronze": 83886080
              }
            }
          }
        }
      }
    },
    "us-west-2-large": {
      "system_types": {
        "powerflex": {
          "system_ids": {
            "2222": {
              "pool_quotas": {
                "bronze": 838860800,
                "silver": 93886080000
              }
            }
          }
        }
      }
    }
  }

test_small_request_allowed {
  allow with input as {
    "claims": {
        "aud": "karavi",
        "exp": 1615426023, 
        "group": "DevOpsGroup1",
        "iss":"com.dell.karavi",
        "roles":"us-east-1",
        "sub":"karavi-tenant"
    },
    "request": {
        "name":"k8s-0fc0695995",
        "protectionDomainId":"6b2ffe6c00000000",
        "storagePoolId":"ae376b0300000000",
        "volumeSizeInKb":"8388608",
        "volumeType":"ThinProvisioned"
    },
    "storagepool":"bronze",
    "storagesystemid":"2222",
    "systemtype": "powerflex"
  } with data.karavi.common.roles as roles
}

test_large_request_not_allowed {
  not allow with input as {
    "claims": {
        "aud": "karavi",
        "exp": 1615426023, 
        "group": "DevOpsGroup1",
        "iss":"com.dell.karavi",
        "roles":"us-west-2-small,us-west-2-large",
        "sub":"karavi-tenant"
    },
    "request": {
        "name":"k8s-0fc0695995",
        "protectionDomainId":"6b2ffe6c00000000",
        "storagePoolId":"ae376b0300000000",
        "volumeSizeInKb":"9999999999",
        "volumeType":"ThinProvisioned"
    },
    "storagepool":"bronze",
    "storagesystemid":"2222",
    "storagetype": "powerflex"
  } with data.karavi.common.roles as roles
}
