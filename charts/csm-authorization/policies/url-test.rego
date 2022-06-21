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

test_get_api_login_allowed {
    allow with input as {"method": "GET", "url": "/api/login/"}
}

test_post_proxy_refresh_token_allowed {
    allow with input as {"method": "POST", "url": "/proxy/refresh-token/"}
}

test_get_api_version_allowed {
    allow with input as {"method": "GET", "url": "/api/version/"}
}

test_get_system_instances_allowed {
    allow with input as {"method": "GET", "url": "/api/types/System/instances/"}
}

test_get_storagpool_instances_allowed {
    allow with input as {"method": "GET", "url": "/api/types/StoragePool/instances/"}
}

test_post_volume_instances_allowed {
    allow with input as {"method": "POST", "url": "/api/types/Volume/instances/"}
}

test_get_volume_instance_allowed {
    allow with input as {"method": "GET", "url": "/api/instances/Volume::2a3814c600000003/"}
}

test_post_volume_instances_queryIdByKey_allowed {
    allow with input as {"method": "POST", "url": "/api/types/Volume/instances/action/queryIdByKey/"}
}

test_get_system_sdc_allowed {
    allow with input as {"method": "GET", "url": "/api/instances/System::7045c4cc20dffc0f/relationships/Sdc/"}
}

test_post_volume_add_sdc_allowed {
    allow with input as {"method": "POST", "url": "/api/instances/Volume::2a3814c600000003/action/addMappedSdc/"}
}

test_post_volume_remove_sdc_allowed {
    allow with input as {"method": "POST", "url": "/api/instances/Volume::2a3814c600000003/action/removeMappedSdc/"}
}

test_post_volume_remove_allowed {
    allow with input as {"method": "POST", "url": "/api/instances/Volume::2a3814c600000003/action/removeVolume/"}
}
