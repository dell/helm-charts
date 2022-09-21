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

package karavi.authz.powerscale.url

allowlist = [
    "GET /platform/latest/",
    "GET /platform/[0-9]/cluster/config/",
    "GET /namespace/(.+)",
    "GET /platform/[0-9]/protocols/nfs/exports/?(.+)",
    "PUT /namespace/(.+)",
    "GET /platform/[0-9]/quota/license/",
    "POST /platform/[0-9]/quota/quotas/",
    "POST /platform/[0-9]/protocols/nfs/exports/?(.+)",
    "GET /platform/[0-9]/protocols/nfs/exports/[0-9]+?(.+)",
    "PUT /platform/[0-9]/protocols/nfs/exports/[0-9]+?(.+)",
    "DELETE /platform/[0-9]/quota/quotas/[a-z0-9A-Z]+/",
    "DELETE /platform/[0-9]/protocols/nfs/exports/[0-9]+?(.+)",
    "DELETE /namespace/(.+)",
    "GET /platform/[0-9]/snapshot/snapshots/(.+)",
    "POST /platform/[0-9]/snapshot/snapshots",
    "DELETE /platform/[0-9]/snapshot/snapshots/(.+)",
    "POST /session/[0-9]/session/",
    "GET /session/[0-9]/session/",
    "POST /proxy/refresh-token/"
]

default allow = true
allow {
	regex.match(allowlist[_], sprintf("%s %s", [input.method, input.url]))
}
