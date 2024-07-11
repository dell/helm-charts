# Copyright © 2024 Dell Inc., or its subsidiaries. All Rights Reserved.
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

package karavi.snapshot.create

import data.karavi.common

default allow := false

allow {
	count(permitted_roles) == count(input.request)
	count(deny) == 0
}

# Deny if there are no roles found.
deny[msg] {
	common.roles == {}
	msg := sprintf("no configured roles", [])
}

# Deny if claimed roles has no match for the request.
deny[msg] {
	count(permitted_roles) != count(input.request)

	unpermitted_requests := [req |
		element := input.request[_]

		not permitted_roles[element.name]

		req := element
	]

	msg := sprintf(
		"no roles in [%s] allow the %s Kb request on %s/%s/%s for %s",
		[
			input.claims.roles,
			unpermitted_requests[_].volumeSizeInKb,
			input.systemtype,
			input.storagesystemid,
			unpermitted_requests[_].storagepool,
			unpermitted_requests[_].name,
		],
	)
}

# No OR in OPA, multiple rules are needed.
size_is_valid(a, b) {
	to_number(a) >= to_number(b)
}

# No OR in OPA, multiple rules are needed.
size_is_valid(a, _) {
	to_number(a) == 0
}

# Create a list of permitted roles.
permitted_roles[snapshot] := roles {
	# Split the claimed roles by comma into an array.
	claimed_roles := split(input.claims.roles, ",")

	# Iterate through the requests.
	req := input.request[_]

	roles := [role |
		sp := req.storagepool
		size := req.volumeSizeInKb

		# Iterate through the roles in the request.
		c_role := claimed_roles[_]
		common.roles[c_role]

		system_ids := common.roles[c_role].system_types[input.systemtype].system_ids[input.storagesystemid]
		pool_quota := system_ids.pool_quotas[sp]

		# Validate that the pool quota is valid.
		size_is_valid(pool_quota, size)

		role := {"size": to_number(pool_quota), "storagepool": sp, "role": c_role}
	]

	# Ensure that the role list is not empty.
	count(roles) != 0

	# Set the snapshot name which creates an entry in the list.
	snapshot := req.name
}
