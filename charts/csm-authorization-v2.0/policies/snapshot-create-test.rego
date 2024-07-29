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

package karavi.snapshot.create_test

import data.karavi.snapshot.create

import rego.v1


test_snapshot_simple_request_allowed if {
	content := {
		"claims": {
			"aud": "karavi",
			"exp": 1615426023,
			"group": "DevOpsGroup1",
			"iss": "com.dell.karavi",
			"roles": "us-east-1",
			"sub": "karavi-tenant",
		},
		"request": [{
			"name": "k8s-0fc0695994-snapshot",
			"protectionDomainId": "6b2ffe6c00000000",
			"storagePoolId": "ae376b0300000000",
			"volumeSizeInKb": "8388608",
			"volumeType": "ThinProvisioned",
			"storagepool": "bronze",
		}],
		"storagesystemid": "2222",
		"systemtype": "powerflex",
	}

	role := {"us-east-1": {"system_types": {"powerflex": {"system_ids": {"2222": {"pool_quotas": {"bronze": "44000000"}}}}}}}

	create.allow with input as content with data.karavi.common.roles as role
}

test_snapshot_multi_role_request_allowed if {
	content := {
		"claims": {
			"aud": "karavi",
			"exp": 1615426023,
			"group": "DevOpsGroup1",
			"iss": "com.dell.karavi",
			"roles": "us-east-1,us-west-1",
			"sub": "karavi-tenant",
		},
		"request": [{
			"name": "k8s-0fc0695994-snapshot",
			"protectionDomainId": "6b2ffe6c00000000",
			"storagePoolId": "ae376b0300000000",
			"volumeSizeInKb": "8388608",
			"volumeType": "ThinProvisioned",
			"storagepool": "bronze",
		}],
		"storagesystemid": "2222",
		"systemtype": "powerflex",
	}

	role := {
		"us-east-1": {"system_types": {"powerflex": {"system_ids": {"2222": {"pool_quotas": {"bronze": "44000000"}}}}}},
		"us-west-1": {"system_types": {"powerflex": {"system_ids": {"2222": {"pool_quotas": {"bronze": 83886080}}}}}},
	}

	create.allow with input as content with data.karavi.common.roles as role
}

test_snapshot_multi_request_allowed if {
	content := {
		"claims": {
			"aud": "karavi",
			"exp": 1615426023,
			"group": "DevOpsGroup1",
			"iss": "com.dell.karavi",
			"roles": "us-east-1,us-west-1",
			"sub": "karavi-tenant",
		},
		"request": [
			{
				"name": "k8s-0fc0695994-snapshot",
				"protectionDomainId": "6b2ffe6c00000000",
				"storagePoolId": "ae376b0300000000",
				"volumeSizeInKb": "8388608",
				"volumeType": "ThinProvisioned",
				"storagepool": "bronze",
			},
			{
				"name": "k8s-0fc0695995-snapshot",
				"protectionDomainId": "6b2ffe6c00000000",
				"storagePoolId": "ae376b0300000000",
				"volumeSizeInKb": "8388608",
				"volumeType": "ThinProvisioned",
				"storagepool": "bronze",
			},
		],
		"storagesystemid": "2222",
		"systemtype": "powerflex",
	}

	role := {"us-east-1": {"system_types": {"powerflex": {"system_ids": {"2222": {"pool_quotas": {"bronze": "44000000"}}}}}}}

	create.allow with input as content with data.karavi.common.roles as role
}

test_snapshot_multi_request_multi_role_allowed if {
	content := {
		"claims": {
			"aud": "karavi",
			"exp": 1615426023,
			"group": "DevOpsGroup1",
			"iss": "com.dell.karavi",
			"roles": "us-east-1,us-west-1",
			"sub": "karavi-tenant",
		},
		"request": [
			{
				"name": "k8s-0fc0695994-snapshot",
				"protectionDomainId": "6b2ffe6c00000000",
				"storagePoolId": "ae376b0300000000",
				"volumeSizeInKb": "8388608",
				"volumeType": "ThinProvisioned",
				"storagepool": "bronze",
			},
			{
				"name": "k8s-0fc0695995-snapshot",
				"protectionDomainId": "6b2ffe6c00000000",
				"storagePoolId": "ae376b0300000000",
				"volumeSizeInKb": "8388608",
				"volumeType": "ThinProvisioned",
				"storagepool": "silver",
			},
		],
		"storagesystemid": "2222",
		"systemtype": "powerflex",
	}

	role := {
		"us-east-1": {"system_types": {"powerflex": {"system_ids": {"2222": {"pool_quotas": {"bronze": "44000000", "silver": "88000000"}}}}}},
		"us-west-1": {"system_types": {"powerflex": {"system_ids": {"2222": {"pool_quotas": {"silver": 83886080}}}}}},
	}

	create.allow with input as content with data.karavi.common.roles as role
}

test_snapshot_empty_request_allowed if {
	content := {
		"claims": {
			"aud": "karavi",
			"exp": 1615426023,
			"group": "DevOpsGroup1",
			"iss": "com.dell.karavi",
			"roles": "us-east-1",
			"sub": "karavi-tenant",
		},
		"request": [],
		"storagesystemid": "2222",
		"systemtype": "powerflex",
	}

	role := {"us-east-1": {"system_types": {"powerflex": {"system_ids": {"2222": {"pool_quotas": {"bronze": "44000000"}}}}}}}

	create.allow with input as content with data.karavi.common.roles as role
}

test_snapshot_infinite_quota_allowed if {
	content := {
		"claims": {
			"aud": "karavi",
			"exp": 1615426023,
			"group": "DevOpsGroup1",
			"iss": "com.dell.karavi",
			"roles": "us-east-1",
			"sub": "karavi-tenant",
		},
		"request": [
			{
				"name": "k8s-0fc0695994-snapshot",
				"protectionDomainId": "6b2ffe6c00000000",
				"storagePoolId": "ae376b0300000000",
				"volumeSizeInKb": "8388608",
				"volumeType": "ThinProvisioned",
				"storagepool": "bronze",
			},
			{
				"name": "k8s-0fc0695995-snapshot",
				"protectionDomainId": "6b2ffe6c00000000",
				"storagePoolId": "ae376b0300000000",
				"volumeSizeInKb": "8388608",
				"volumeType": "ThinProvisioned",
				"storagepool": "bronze",
			},
		],
		"storagesystemid": "2222",
		"systemtype": "powerflex",
	}

	role := {"us-east-1": {"system_types": {"powerflex": {"system_ids": {"2222": {"pool_quotas": {"bronze": 0}}}}}}}

	create.allow with input as content with data.karavi.common.roles as role
}

test_snapshot_deny_role_with_insufficient_quota if {
	content := {
		"claims": {
			"aud": "karavi",
			"exp": 1615426023,
			"group": "DevOpsGroup1",
			"iss": "com.dell.karavi",
			"roles": "us-east-1",
			"sub": "karavi-tenant",
		},
		"request": [
			{
				"name": "k8s-0fc0695994-snapshot",
				"protectionDomainId": "6b2ffe6c00000000",
				"storagePoolId": "ae376b0300000000",
				"volumeSizeInKb": "8388608",
				"volumeType": "ThinProvisioned",
				"storagepool": "bronze",
			},
			{
				"name": "k8s-0fc0695995-snapshot",
				"protectionDomainId": "6b2ffe6c00000000",
				"storagePoolId": "ae376b0300000000",
				"volumeSizeInKb": "8388608",
				"volumeType": "ThinProvisioned",
				"storagepool": "bronze",
			},
		],
		"storagesystemid": "2222",
		"systemtype": "powerflex",
	}

	role := {"us-east-1": {"system_types": {"powerflex": {"system_ids": {"2222": {"pool_quotas": {"bronze": "10"}}}}}}}

	result := create.deny with input as content with data.karavi.common.roles as role

	count(result) != 0
}

test_snapshot_deny_multiple_roles_with_not_permitted_pool if {
	content := {
		"claims": {
			"aud": "karavi",
			"exp": 1615426023,
			"group": "DevOpsGroup1",
			"iss": "com.dell.karavi",
			"roles": "us-east-1,us-west-1",
			"sub": "karavi-tenant",
		},
		"request": [
			{
				"name": "k8s-0fc0695994-snapshot",
				"protectionDomainId": "6b2ffe6c00000000",
				"storagePoolId": "ae376b0300000000",
				"volumeSizeInKb": "8388608",
				"volumeType": "ThinProvisioned",
				"storagepool": "bronze",
			},
			{
				"name": "k8s-0fc0695995-snapshot",
				"protectionDomainId": "6b2ffe6c00000000",
				"storagePoolId": "ae376b0300000000",
				"volumeSizeInKb": "8388608",
				"volumeType": "ThinProvisioned",
				"storagepool": "yellow",
			},
		],
		"storagesystemid": "2222",
		"systemtype": "powerflex",
	}

	role := {
		"us-east-1": {"system_types": {"powerflex": {"system_ids": {"2222": {"pool_quotas": {"bronze": "44000000"}}}}}},
		"us-west-1": {"system_types": {"powerflex": {"system_ids": {"2222": {"pool_quotas": {"silver": 4000000}}}}}},
	}

	result := create.deny with input as content with data.karavi.common.roles as role

	count(result) != 0
}

test_snapshot_deny_multiple_roles_with_insufficient_quota if {
	content := {
		"claims": {
			"aud": "karavi",
			"exp": 1615426023,
			"group": "DevOpsGroup1",
			"iss": "com.dell.karavi",
			"roles": "us-east-1,us-west-1",
			"sub": "karavi-tenant",
		},
		"request": [
			{
				"name": "k8s-0fc0695994-snapshot",
				"protectionDomainId": "6b2ffe6c00000000",
				"storagePoolId": "ae376b0300000000",
				"volumeSizeInKb": "8388608",
				"volumeType": "ThinProvisioned",
				"storagepool": "bronze",
			},
			{
				"name": "k8s-0fc0695995-snapshot",
				"protectionDomainId": "6b2ffe6c00000000",
				"storagePoolId": "ae376b0300000000",
				"volumeSizeInKb": "8388608",
				"volumeType": "ThinProvisioned",
				"storagepool": "silver",
			},
		],
		"storagesystemid": "2222",
		"systemtype": "powerflex",
	}

	role := {
		"us-east-1": {"system_types": {"powerflex": {"system_ids": {"2222": {"pool_quotas": {"bronze": "44000000"}}}}}},
		"us-west-1": {"system_types": {"powerflex": {"system_ids": {"2222": {"pool_quotas": {"silver": 4000000}}}}}},
	}

	result := create.deny with input as content with data.karavi.common.roles as role

	count(result) != 0
}

test_snapshot_deny_empty_roles if {
	content := {
		"claims": {
			"aud": "karavi",
			"exp": 1615426023,
			"group": "DevOpsGroup1",
			"iss": "com.dell.karavi",
			"roles": "us-east-1",
			"sub": "karavi-tenant",
		},
		"request": [{
			"name": "k8s-0fc0695994-snapshot",
			"protectionDomainId": "6b2ffe6c00000000",
			"storagePoolId": "ae376b0300000000",
			"volumeSizeInKb": "8388608",
			"volumeType": "ThinProvisioned",
			"storagepool": "bronze",
		}],
		"storagesystemid": "2222",
		"systemtype": "powerflex",
	}

	create.deny["no configured roles"] with input as content with data.karavi.common.roles as {}
}
