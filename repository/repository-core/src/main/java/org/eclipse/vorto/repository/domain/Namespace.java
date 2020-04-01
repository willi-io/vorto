/**
 * Copyright (c) 2020 Contributors to the Eclipse Foundation
 *
 * See the NOTICE file(s) distributed with this work for additional
 * information regarding copyright ownership.
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * https://www.eclipse.org/legal/epl-2.0
 *
 * SPDX-License-Identifier: EPL-2.0
 */
package org.eclipse.vorto.repository.domain;

import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import org.eclipse.vorto.model.ModelId;
import org.hibernate.annotations.NaturalId;
import com.google.common.collect.Lists;

@Entity
@Table(name = "namespace")
public class Namespace {

  public static final String PRIVATE_NAMESPACE_PREFIX = "vorto.private.";
  
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  // TODO remove
  @ManyToOne
  @JoinColumn(name = "tenant_id")
  private Tenant tenant;

  @ManyToOne
  @JoinColumn(name = "owner_user_id", referencedColumnName = "id")
  private User owner;

  @NaturalId
  private String name;

  // TODO move biz logic away
  public static Collection<Namespace> toNamespace(Collection<String> namespaces, Tenant tenant) {
    return namespaces.stream().map(name -> {
      Namespace namespace = new Namespace();
      namespace.setName(name);
      namespace.setTenant(tenant);
      return namespace;
    }).collect(Collectors.toList());
  }

  public static Namespace newNamespace(String name) {
    Namespace namespace = new Namespace();
    namespace.setName(name);
    return namespace;
  }

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public User getOwner() {
    return owner;
  }

  public void setOwner(User owner) {
    this.owner = owner;
  }

  public Tenant getTenant() {
    return tenant;
  }

  public void setTenant(Tenant tenant) {
    this.tenant = tenant;
  }
  
  public boolean owns(ModelId modelId) {
    return in(getName(), components(modelId.getNamespace()));
  }
  
  public boolean owns(String namespace) {
    return in(getName(), components(namespace));
  }
  
  public boolean isInConflictWith(String namespace) {
    return in(namespace, components(getName())) || in(getName(), components(namespace));
  }
  
  private String[] components(String namespace) {
    String[] breakdown = namespace.split("\\.");
    List<String> components = Lists.newArrayList();
    for(int i=1; i <= breakdown.length; i++) {
      components.add(String.join(".", Arrays.copyOfRange(breakdown, 0, i)));
    }
    return components.toArray(new String[components.size()]);
  }
  
  private boolean in(String str, String[] strings) {
    return Arrays.stream(strings).anyMatch(str::equals);
  }
}
