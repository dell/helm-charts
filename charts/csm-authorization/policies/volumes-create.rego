# Copyright © 2022 Dell Inc., or its subsidiaries. All Rights Reserved.
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

import data.karavi.common

# Deny requests by default.
default allow = false

#
# Allows the request if one of the claimed roles matches
# a role configured to allow the storage request.
#
allow {
  count(permitted_roles) != 0
  count(deny) == 0
}

#
# Deny if there are no roles found.
#
deny[msg] {
  common.roles == {}
  msg := sprintf("no configured roles", [])
}

#
# Deny if claimed roles has no match for the request.
#
deny[msg] {
  count(permitted_roles) == 0
  msg := sprintf("no roles in [%s] allow the %s Kb request on %s/%s/%s",
           [input.claims.roles,
           input.request.volumeSizeInKb,
           input.systemtype,
           input.storagesystemid,
           input.storagepool])
}

#
# These are permitted roles that are configured
# with the requested storage system, mapped to
# the allowable quota for the request storage
# pool.
#
# Example: { "role-1": 800000 }
#
permitted_roles[v] = y {
  # Split the claimed roles by comma into an array.
  claimed_roles := split(input.claims.roles, ",")

  # This block filters 'a' to contain only roles
  # that are found in 'common.roles'.
  some i
  a := claimed_roles[i]
  common.roles[a]

  # v will contain permitted roles that match the storage request.
  v := claimed_roles[i]
  common.roles[v].system_types[input.systemtype].system_ids[input.storagesystemid].pool_quotas[input.storagepool] >= to_number(input.request.volumeSizeInKb)
  y := to_number(common.roles[v].system_types[input.systemtype].system_ids[input.storagesystemid].pool_quotas[input.storagepool])
}

# These are the permitted roles that are configured
# with zero quota, meaning infinite capacity.
#
permitted_roles[v] = y {
  # Split the claimed roles by comma into an array.
  claimed_roles := split(input.claims.roles, ",")

  # This block filters 'a' to contain only roles
  # that are found in 'common.roles'.
  some i
  a := claimed_roles[i]
  common.roles[a]

  # v will contain permitted roles that match the storage request.
  v := claimed_roles[i]
  common.roles[v].system_types[input.systemtype].system_ids[input.storagesystemid].pool_quotas[input.storagepool] == 0
  y := to_number(common.roles[v].system_types[input.systemtype].system_ids[input.storagesystemid].pool_quotas[input.storagepool])
}
