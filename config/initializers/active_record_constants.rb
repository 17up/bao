#coding: utf-8

PLAN_CATEGORIES = {
  return: '老客户',
  new: '潜在客户',
  custom: '自定义名单',
  personal: '个性化筛选',
  merchant: '指定商户触发',
  model: '模型触发'
}

MEMBER_CATEGORIES = {
  merchant: '商户账号',
  upsmart: '系统账号',
  agent: '代理账号'
}

STORE_STATUS = {
   "" => '未开始',
  '0' => '正在执行中',
  '1' => '已完成',
  '-1' => '执行失败'
}

ORDER_STATUS = {
  pending: '待审核',
  approve: '充值成功',
  reject: '充值不成功'
}

AUDIT_STATUS = {
  pending: '待审核',
  approve: '审核通过',
  reject: '审核不通过',
  freezed: '冻结' 
}