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

package karavi.authz.url

allowlist = [
    "GET /api/login/",
		"POST /proxy/refresh-token/",
		"GET /api/version/",
		"GET /api/types/System/instances/",
		"GET /api/types/StoragePool/instances/",
		"POST /api/types/Volume/instances/",
		"GET /api/instances/Volume::[a-f0-9]+/$",
		"POST /api/types/Volume/instances/action/queryIdByKey/",
		"GET /api/instances/System::[a-f0-9]+/relationships/Sdc/",
		"GET /api/instances/Sdc::[a-f0-9]+/relationships/Statistics/",
		"GET /api/instances/Sdc::[a-f0-9]+/relationships/Volume/",
		"GET /api/instances/Volume::[a-f0-9]+/relationships/Statistics/",
		"GET /api/instances/StoragePool::[a-f0-9]+/relationships/Statistics/",
		"POST /api/instances/Volume::[a-f0-9]+/action/addMappedSdc/",
		"POST /api/instances/Volume::[a-f0-9]+/action/removeMappedSdc/",
		"POST /api/instances/Volume::[a-f0-9]+/action/removeVolume/"
]

default allow = true
allow {
	regex.match(allowlist[_], sprintf("%s %s", [input.method, input.url]))
}
