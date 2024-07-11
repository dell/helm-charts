# Copyright © 2023 Dell Inc., or its subsidiaries. All Rights Reserved.
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

package karavi.sdc.approve

import data.karavi.common

# Allow requests by default.
default allow = true

default response = {
	"allowed": true
}
response = {
    "allowed": false,
    "status": {
        "reason": reason,
    },
} {
    reason = concat(", ", deny)
    reason != ""
}

default claims = {}
claims = input.claims
deny[msg] {
  claims == {}
  msg := sprintf("missing claims", [])
}
