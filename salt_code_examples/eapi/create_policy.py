#!/usr/bin/env python3
#

from sseapiclient import APIClient

#  NOTE: Set these as required
SSE_URL = "https://localhost"
SSE_USER = "root"
SSE_PASSWORD = "salt"

POLICY_NAME = "Test1"
TARGET_NAME = "All Minions"
BENCHMARK_SEARCH_TERM = "CentOS_Linux_7_Benchmark"

client = APIClient(SSE_URL, SSE_USER, SSE_PASSWORD, ssl_validate_cert=False)

benchmarks = [
    benchmark
    for benchmark in client.api.sec.get_benchmarks().ret["results"]
    if BENCHMARK_SEARCH_TERM in benchmark["name"]
]
print("Found matching benchmarks...")
for benchmark in benchmarks:
    print("  {}".format(benchmark["name"]))

checks = [
    check
    for check in client.api.sec.get_checks(
        benchmark_uuids=[b["uuid"] for b in benchmarks], limit=1000
    ).ret["results"]
]
print("Found matching checks...")
for check in checks:
    print("  {}".format(check["name"]))

print("Creating policy {}".format(POLICY_NAME))
client.api.sec.save_policy(
    name=POLICY_NAME,
    tgt_uuid=client.api.tgt.get_target_group(name=TARGET_NAME).ret["results"][0][
        "uuid"
    ],
    benchmark_uuids=[benchmark["uuid"] for benchmark in benchmarks],
    check_uuids=[check["uuid"] for check in checks],
)