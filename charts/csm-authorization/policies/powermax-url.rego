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

package karavi.authz.powermax.url

allowlist = [
	"GET /univmax/restapi/version",
	"GET /univmax/restapi/(90|91)/system/symmetrix/[a-f0-9A-F]+",
	"GET /univmax/restapi/(90|91)/sloprovisioning/symmetrix/[a-f0-9A-F]+/srp",
	"GET /univmax/restapi/(90|91)/sloprovisioning/symmetrix/[a-f0-9A-F]+/storagegroup",
	"POST /univmax/restapi/(90|91)/sloprovisioning/symmetrix/[a-f0-9A-F]+/storagegroup",
	"GET /univmax/restapi/(90|91)/sloprovisioning/symmetrix/[a-f0-9A-F]+/storagegroup/(.+)",
	"PUT /univmax/restapi/(90|91)/sloprovisioning/symmetrix/[a-f0-9A-F]+/storagegroup/(.+)",
	"GET /univmax/restapi/(90|91)/sloprovisioning/symmetrix/[a-f0-9A-F]+/volume",
	"GET /univmax/restapi/(90|91)/sloprovisioning/symmetrix/[a-f0-9A-F]+/volume/[a-f0-9A-F]+",
	"PUT /univmax/restapi/(90|91)/sloprovisioning/symmetrix/[a-f0-9A-F]+/volume/[a-f0-9A-F]+",
	"DELETE /univmax/restapi/(90|91)/sloprovisioning/symmetrix/[a-f0-9A-F]+/volume/[a-f0-9A-F]+",
	"DELETE /univmax/restapi/(90|91)/sloprovisioning/symmetrix/[a-f0-9A-F]+/storagegroup/[a-f0-9A-F]+",
	"GET /univmax/restapi/(90|91)/sloprovisioning/symmetrix/[a-f0-9A-F]+/volume/[a-f0-9A-F]+/snapshot",
	"GET /univmax/restapi/91/sloprovisioning/symmetrix/[a-f0-9A-F]+/portgroup/(.+)",
	"GET /univmax/restapi/(90|91)/sloprovisioning/symmetrix/[a-f0-9A-F]+/initiator",
	"GET /univmax/restapi/(90|91)/sloprovisioning/symmetrix/[a-f0-9A-F]+/host/(.+)",
	"GET /univmax/restapi/(90|91)/sloprovisioning/symmetrix/[a-f0-9A-F]+/maskingview/(.+)",
	"GET /univmax/restapi/(90|91)/system/symmetrix",
	"GET /univmax/restapi/private/(90|91)/replication/symmetrix/[a-f0-9A-F]+/volume/[a-f0-9A-F]+/snapshot",
	"GET /univmax/restapi/private/(90|91)/replication/symmetrix/[a-f0-9A-F]+/volume/",
	"DELETE /univmax/restapi/(90|91)/sloprovisioning/symmetrix/[a-f0-9A-F]+/maskingview/(.+)",
	"GET /univmax/restapi/(90|91)/replication/capabilities/symmetrix/",
	"POST /univmax/restapi/(90|91)/sloprovisioning/symmetrix/[a-f0-9A-F]+/maskingview",
]

default allow = true

allow {
	regex.match(allowlist[_], sprintf("%s %s", [input.method, input.url]))
}
